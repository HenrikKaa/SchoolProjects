-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 08
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tb_audio_ctrl.vhd.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2021-01-24
-- Last update: 2021-01-24
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Multi port adder test bench
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author      Description
-- 2020-01-24  1.0      xxx        	Created
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

ENTITY tb_audio_ctrl IS

  GENERIC (
    ref_clk_freq_g : INTEGER := 12288000;
    sample_rate_g : INTEGER := 48000;
    data_width_g : INTEGER := 16
  );

END tb_audio_ctrl;

-- Test bend architecture
ARCHITECTURE testbench OF tb_audio_ctrl IS

  CONSTANT clk_period_c : TIME := 10 ns;

  -- Clock and reset low signals
  SIGNAL clk : STD_LOGIC := '0';
  SIGNAL rst_n : STD_LOGIC := '0';

  -- Signal definitions
  SIGNAL l_data_codec_tb : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL r_data_codec_tb : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL l_data_wg_actrl : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL r_data_wg_actrl : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL aud_bit_clk : STD_LOGIC;
  SIGNAL aud_lr_clk : STD_LOGIC;
  SIGNAL aud_data : STD_LOGIC;

  -- Component declarations
  COMPONENT wave_gen
    GENERIC (
      width_g : INTEGER;
      step_g : INTEGER);

    PORT (
      clk : IN STD_LOGIC;
      rst_n : IN STD_LOGIC;
      sync_clear_n_in : IN STD_LOGIC;
      value_out : OUT STD_LOGIC_VECTOR(width_g - 1 DOWNTO 0)
    );
  END COMPONENT wave_gen;

  COMPONENT audio_ctrl
    GENERIC (
      ref_clk_freq_g : INTEGER;
      sample_rate_g : INTEGER;
      data_width_g : INTEGER
    );

    PORT (
      clk : IN STD_LOGIC;
      rst_n : IN STD_LOGIC;
      left_data_in : IN STD_LOGIC_VECTOR(data_width_g - 1 DOWNTO 0);
      right_data_in : IN STD_LOGIC_VECTOR(data_width_g - 1 DOWNTO 0);
      aud_bclk_out : OUT STD_LOGIC;
      aud_data_out : OUT STD_LOGIC;
      aud_lrclk_out : OUT STD_LOGIC
    );
  END COMPONENT audio_ctrl;

  COMPONENT audio_codec_model
    GENERIC (
      data_width_g : INTEGER := 16);

    PORT (
      rst_n : IN STD_LOGIC;
      aud_data_in : IN STD_LOGIC;
      aud_bclk_in : IN STD_LOGIC;
      aud_lrclk_in : IN STD_LOGIC;
      value_left_out : OUT STD_LOGIC_VECTOR(data_width_g - 1 DOWNTO 0);
      value_right_out : OUT STD_LOGIC_VECTOR(data_width_g - 1 DOWNTO 0)
    );
  END COMPONENT audio_codec_model;

BEGIN --testbench

  -- Generate clock signal
  clk <= NOT clk AFTER clk_period_c/2;

  -- Set reset off after 4 clock cycles
  rst_n <= '1' AFTER clk_period_c * 4;

  -- DUTS ARE INSTANTIATED HERE
  wave_gen_1 : wave_gen
  GENERIC MAP(
    width_g => 16,
    step_g => 2)

  PORT MAP(
    clk => clk,
    rst_n => rst_n,
    sync_clear_n_in => rst_n,
    value_out => l_data_wg_actrl
  );

  wave_gen_2 : wave_gen
  GENERIC MAP(
    width_g => 16,
    step_g => 10)

  PORT MAP(
    clk => clk,
    rst_n => rst_n,
    sync_clear_n_in => rst_n,
    value_out => r_data_wg_actrl
  );

  audio_ctrl_1 : audio_ctrl
  GENERIC MAP(
    ref_clk_freq_g => ref_clk_freq_g,
    sample_rate_g => sample_rate_g,
    data_width_g => data_width_g
  )

  PORT MAP(
    clk => clk,
    rst_n => rst_n,
    left_data_in => l_data_wg_actrl,
    right_data_in => r_data_wg_actrl,
    aud_bclk_out => aud_bit_clk,
    aud_data_out => aud_data,
    aud_lrclk_out => aud_lr_clk
  );

  audio_codec_model_1 : audio_codec_model
  GENERIC MAP(
    data_width_g => data_width_g)

  PORT MAP(
    rst_n => rst_n,
    aud_data_in => aud_data,
    aud_bclk_in => aud_bit_clk,
    aud_lrclk_in => aud_lr_clk,
    value_left_out => l_data_codec_tb,
    value_right_out => r_data_codec_tb
  );

  -- This process checks that the codec output waveform matches the ones at wavegenerator outputs
  -- with a delay of one aud_lr_clk clock cycle.
  checker : PROCESS (clk, rst_n)
    VARIABLE previous_aud_lr_clk : STD_LOGIC;
    VARIABLE previous_l_data_wg_actrl : INTEGER;
    VARIABLE previous_r_data_wg_actrl : INTEGER;

  BEGIN -- process wave_generation
    IF (rst_n = '0') THEN -- If reset is active

      previous_aud_lr_clk := '0';
      previous_l_data_wg_actrl := 0;
      previous_r_data_wg_actrl := 0;

    ELSIF (clk'event AND clk = '1') THEN -- On rising clock edge

      -- When aud_lr_clk rising edge
      IF ((aud_lr_clk /= previous_aud_lr_clk) AND (aud_lr_clk = '1')) THEN

        -- Run asserts after signals have obtained their first running values
        IF ((previous_l_data_wg_actrl /= 0) AND (to_integer(signed(l_data_codec_tb)) /= 0)) THEN

          -- Check that current audio codec model outputs
          -- match wave generator output values at previous
          -- aud_lr_clk rising edge

          ASSERT(to_integer(signed(l_data_codec_tb)) /= previous_l_data_wg_actrl)
          REPORT "l_data_codec_tb does not match previous_l_data_wg_actrl"
            SEVERITY failure;

          ASSERT(to_integer(signed(r_data_codec_tb)) /= previous_r_data_wg_actrl)
          REPORT "r_data_codec_tb does not match previous_r_data_wg_actrl"
            SEVERITY failure;
        END IF;

        -- Update saved previous_signal values for the next assert round
        previous_l_data_wg_actrl := to_integer(signed(l_data_wg_actrl));
        previous_r_data_wg_actrl := to_integer(signed(r_data_wg_actrl));

      END IF;

      -- Update previous_aud_lr_clk to its current value
      previous_aud_lr_clk := aud_lr_clk;

    END IF;
  END PROCESS checker;

END ARCHITECTURE testbench;