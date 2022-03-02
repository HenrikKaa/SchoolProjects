-------------------------------------------------------------------------------
-- Title      : COMP.CE.240 Exercise 11
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2c_config.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2021-02-14
-- Last update: 2021-02-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-02-14  1.0      xxx     	  	Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE std.textio.ALL;

ENTITY i2c_config IS

  GENERIC (
    ref_clk_freq_g : INTEGER := 50000000; --Hz
    i2c_freq_g : INTEGER := 20000; --Hz, (2c-bus (sclk_out) frequency)
    n_params_g : INTEGER := 15; -- number of configuration parameters
    n_leds_g : INTEGER := 4 -- number of leds on the board
  );

  PORT (
    clk : IN STD_LOGIC;
    rst_n : IN STD_LOGIC;
    sdat_inout : INOUT STD_LOGIC; -- bus data out
    sclk_out : OUT STD_LOGIC; -- bus clock out

    -- signal with LEDs the tranmission state
    param_status_out : OUT STD_LOGIC_VECTOR(n_leds_g - 1 DOWNTO 0);
    finished_out : OUT STD_LOGIC -- Signal that all the transmissions are finished
  );

END ENTITY i2c_config;

ARCHITECTURE i2c OF i2c_config IS

  -- States for the i2c state machine are created
  TYPE state_type IS (start_state_1, start_state_2, delay_1, delay_2,
    data_transmit_state_1, delay_3, data_transmit_state_2, delay_4,
    data_transmit_state_3, delay_5, data_transmit_state_4, ack_listening_state_1,
    delay_6, ack_listening_state_2, delay_7, ack_listening_state_3, delay_8,
    ack_listening_state_4, ack_listening_state_5, ack_listening_state_5_1, delay_9,
    delay_9_1, ack_listening_state_6, delay_10, ack_listening_state_7,
    delay_before_finished_out, end_state);

  SIGNAL present_state_r : state_type;

  -- This keeps track which data type has to be sent next
  SIGNAL curr_data_type_r : INTEGER RANGE 0 TO 3;

  -- transmission target address with the leading write-bit
  CONSTANT device_address_c : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00110100";

  -- All the other data to send is in the following array:
  TYPE data_array IS ARRAY (n_params_g - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL i2c_data_array : data_array;

  -- Counter to keep track of the current register address and value integer
  SIGNAL present_data_idx_r : INTEGER RANGE 0 TO 15;

  -- Keeps count how many bits have been written into single register
  SIGNAL register_bit : INTEGER RANGE 0 TO 16;

  -- Helper signal, keeps track if endstate is reached
  SIGNAL endstate_true : STD_LOGIC;

  -- Counter with period period for 1/8 of the required i2c_freq_g clock rate
  CONSTANT counter_state_change_c : INTEGER := INTEGER(floor(real(ref_clk_freq_g)/real(i2c_freq_g)/real(16)));

  -- Counter edges are computed
  SIGNAL counter_edge_count : INTEGER RANGE 0 TO 100;

  -- Determines at which counter value the delay ends
  SIGNAL delay_stop_val : INTEGER RANGE 0 TO 100;

  -- Create clock signal and the actual counting signal
  SIGNAL cntr_event_clk : STD_LOGIC;
  SIGNAL counter : INTEGER RANGE 0 TO counter_state_change_c;

BEGIN -- i2c_config

  i2c_data_array(0) <= "0001110110000000";
  i2c_data_array(1) <= "0010011100000100";
  i2c_data_array(2) <= "0010001000001011";
  i2c_data_array(3) <= "0010100000000000";
  i2c_data_array(4) <= "0010100110000001";
  i2c_data_array(5) <= "0110100100001000";
  i2c_data_array(6) <= "0110101000000000";
  i2c_data_array(7) <= "0100011111100001";
  i2c_data_array(8) <= "0110101100001001";
  i2c_data_array(9) <= "0110110000001000";
  i2c_data_array(10) <= "0100101100001000";
  i2c_data_array(11) <= "0100110000001000";
  i2c_data_array(12) <= "0110111010001000";
  i2c_data_array(13) <= "0110111110001000";
  i2c_data_array(14) <= "0101000111110001";


  -- This process crates a clock signal which can be used by the actual state machine 
  -- to switch states. The generated clock signal is 8 times faster than the eventual i2c
  -- bus clock signal.
  i2c_state_machine_clock_process : PROCESS (clk, rst_n) IS

  BEGIN -- process i2c_state_machine_clock_process

    IF rst_n = '0' THEN -- asynchronous reset (active low)

      cntr_event_clk <= '0';
      counter <= 0;
      counter_edge_count <= 0;

    ELSIF clk'event AND clk = '1' THEN -- rising clock edge

      IF (counter = counter_state_change_c) THEN

        cntr_event_clk <= NOT(cntr_event_clk);
        counter <= 0;

        IF (counter_edge_count < 100) THEN
          counter_edge_count <= counter_edge_count + 1;
        ELSE
          counter_edge_count <= 0;
        END IF;

      ELSE
        counter <= counter + 1;
      END IF;
    END IF;
  END PROCESS i2c_state_machine_clock_process;


  -- The actual state machine for the shield initialisation process
  i2c_state_machine : PROCESS (clk, rst_n) IS

  BEGIN -- process i2c_state_machine
    IF rst_n = '0' THEN -- asynchronous reset (active low)

      -- The both out lines are set to one according to the i2c standard:
      sclk_out <= '1';
      sdat_inout <= '1';
      present_data_idx_r <= 0;
      present_state_r <= start_state_1;
      curr_data_type_r <= 0;
      param_status_out <= (OTHERS => '0');
      delay_stop_val <= 0;
      register_bit <= 0;
      finished_out <= '0';
      endstate_true <= '0';

    ELSIF clk'event AND clk = '1' THEN -- rising clock edge

      CASE present_state_r IS
        WHEN start_state_1 =>

          -- Make sure that SDA and SCL have been up for long enough
          sclk_out <= '1';
          sdat_inout <= '1';

          -- WAIT FOR sclk_period
          IF (counter_edge_count + 16 <= 100) THEN
            delay_stop_val <= counter_edge_count + 16;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 16;
          END IF;
          present_state_r <= delay_1;

        WHEN delay_1 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= start_state_2;
          END IF;

        WHEN start_state_2 =>
          -- sclk signal is kept at 1 while sdat is pulled down to 
          -- start the transmission
          sclk_out <= '1';
          sdat_inout <= '0';

          -- Wait before pulling the clock signal down in the next state
          -- WAIT FOR sclk_period/4;
          IF (counter_edge_count + 4 <= 100) THEN
            delay_stop_val <= counter_edge_count + 4;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 4;
          END IF;
          present_state_r <= delay_2;

        WHEN delay_2 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= data_transmit_state_1;
          END IF;

        WHEN data_transmit_state_1 =>
          sclk_out <= '0'; -- pull clock signal down
          -- WAIT FOR sclk_period/4
          IF (counter_edge_count + 4 <= 100) THEN
            delay_stop_val <= counter_edge_count + 4;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 4;
          END IF;
          present_state_r <= delay_3;

        WHEN delay_3 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= data_transmit_state_2;
          END IF;

        WHEN data_transmit_state_2 =>
          IF (curr_data_type_r = 0) THEN -- If device address data
            sdat_inout <= device_address_c(7 - register_bit); -- write bit to output MSB first

          ELSIF (curr_data_type_r = 1) THEN -- If register address data
            sdat_inout <= i2c_data_array(present_data_idx_r)(15 - register_bit); -- write bit to output MSB first

          ELSE -- If register value data
            sdat_inout <= i2c_data_array(present_data_idx_r)(15 - register_bit - 8); -- write bit to output MSB first

          END IF;

          -- WAIT FOR sclk_period/4
          IF (counter_edge_count + 4 <= 100) THEN
            delay_stop_val <= counter_edge_count + 4;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 4;
          END IF;
          present_state_r <= delay_4;

        WHEN delay_4 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= data_transmit_state_3;
          END IF;

        WHEN data_transmit_state_3 =>
          sclk_out <= '1'; -- pull clock signal up

          -- WAIT FOR sclk_period/2
          IF (counter_edge_count + 8 <= 100) THEN
            delay_stop_val <= counter_edge_count + 8;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 8;
          END IF;
          present_state_r <= delay_5;

        WHEN delay_5 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= data_transmit_state_4;
          END IF;

        WHEN data_transmit_state_4 =>
          register_bit <= register_bit + 1; -- Keep count how many bits have been written
          IF (register_bit < 7) THEN
            present_state_r <= data_transmit_state_1;
          ELSE
            present_state_r <= ack_listening_state_1;
          END IF;

        WHEN ack_listening_state_1 =>
          register_bit <= 0; -- Prepare the system for the next 8 bits
          sclk_out <= '0';

          -- WAIT FOR sclk_period/8
          IF (counter_edge_count + 2 <= 100) THEN
            delay_stop_val <= counter_edge_count + 2;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 2;
          END IF;
          present_state_r <= delay_6;

        WHEN delay_6 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= ack_listening_state_2;
          END IF;

        WHEN ack_listening_state_2 =>
          sdat_inout <= 'Z'; -- Set output to high-impedance state

          -- WAIT FOR sclk_period * 3/8
          IF (counter_edge_count + 6 <= 100) THEN
            delay_stop_val <= counter_edge_count + 6;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 6;
          END IF;
          present_state_r <= delay_7;

        WHEN delay_7 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= ack_listening_state_3;
          END IF;

        WHEN ack_listening_state_3 =>
          sclk_out <= '1';

          -- Set delay timer to WAIT FOR sclk_period/2
          IF (counter_edge_count + 8 <= 100) THEN
            delay_stop_val <= counter_edge_count + 8;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 8;
          END IF;
          present_state_r <= delay_8;

        WHEN delay_8 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;

          ELSE
            IF sdat_inout = '0' THEN -- In case the data has been recieved correctly
              present_state_r <= ack_listening_state_4;
            ELSE
              present_state_r <= ack_listening_state_5;

            END IF;
          END IF;

        WHEN ack_listening_state_4 =>
          IF curr_data_type_r < 2 THEN -- If each current (three) registers have not been yet written completely
            curr_data_type_r <= curr_data_type_r + 1;
            present_state_r <= data_transmit_state_1;

          ELSE -- Move to next registers if each current (three) registers have been written completely
            IF present_data_idx_r < 14 THEN -- If all settings have not already been written

              curr_data_type_r <= 0; -- Set the device address for writing in the next set of three values
              present_data_idx_r <= present_data_idx_r + 1; -- Set the next three registers to be written

              -- Output the status of the system with the LEDs
              param_status_out <= STD_LOGIC_VECTOR(to_unsigned(present_data_idx_r+1, param_status_out'length));
              present_state_r <= ack_listening_state_5; -- End the 3 byte transmission and move back to start state

            ELSE --When each of the 15 registers are written
              endstate_true <= '1'; -- The transmissions are ended when end_state is rached

              -- WAIT FOR 2 sclk_periods before settingfinished_out to one in the end state
              IF (counter_edge_count + 32 <= 100) THEN
                delay_stop_val <= counter_edge_count + 32;
              ELSE
                delay_stop_val <= counter_edge_count - 101 + 32;
              END IF;
              present_state_r <= delay_before_finished_out;

            END IF;
          END IF;

          -- Three-byte transmission end signal is given
        WHEN ack_listening_state_5 =>
          sclk_out <= '0';

          -- WAIT FOR sclk_period/4
          IF (counter_edge_count + 4 <= 100) THEN
            delay_stop_val <= counter_edge_count + 4;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 4;
          END IF;

          present_state_r <= delay_9;

        WHEN delay_9 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= ack_listening_state_5_1;
          END IF;

        WHEN ack_listening_state_5_1 =>
          sdat_inout <= '0';

          -- WAIT FOR sclk_period/4
          IF (counter_edge_count + 4 <= 100) THEN
            delay_stop_val <= counter_edge_count + 4;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 4;
          END IF;

          present_state_r <= delay_9_1;

        WHEN delay_9_1 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= ack_listening_state_6;
          END IF;

        WHEN ack_listening_state_6 =>
          sclk_out <= '1';

          -- WAIT FOR sclk_period/4
          IF (counter_edge_count + 4 <= 100) THEN
            delay_stop_val <= counter_edge_count + 4;
          ELSE
            delay_stop_val <= counter_edge_count - 101 + 4;
          END IF;
          present_state_r <= delay_10;

        WHEN delay_10 =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= ack_listening_state_7;
          END IF;

        WHEN ack_listening_state_7 =>
          -- Set sdat to one on when clk is up to denote end of current byte transmission
          sdat_inout <= '1';

          IF (endstate_true = '1') THEN
            -- WAIT FOR 2 sclk_periods before settingfinished_out to one in the end state
            IF (counter_edge_count + 32 <= 100) THEN
              delay_stop_val <= counter_edge_count + 32;
            ELSE
              delay_stop_val <= counter_edge_count - 101 + 32;
            END IF;
            present_state_r <= delay_before_finished_out;

          ELSE
            -- Reinitialise the transmission
            curr_data_type_r <= 0; -- Set the device address for writing in the next set of three values
            present_state_r <= start_state_1;

          END IF;

        WHEN delay_before_finished_out =>
          IF (counter_edge_count /= delay_stop_val) THEN
            present_state_r <= present_state_r;
          ELSE
            present_state_r <= end_state;
          END IF;

        WHEN end_state =>
          finished_out <= '1';

      END CASE;
    END IF;
  END PROCESS i2c_state_machine;

END ARCHITECTURE i2c;