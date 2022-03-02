-------------------------------------------------------------------------------
-- Title      : COMP.CE.240 Exercise 08
-- Project    : 
-------------------------------------------------------------------------------
-- File       : audio_codec_model.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2021-01-16
-- Last update: 2021-01-22
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-01-16  1.0      Kaakkolammi     Created
-- 2021-01-22  1.1      Kaakkolammi     Fixed right channel and timing overall
-- 2021-01-23  1.2      Kaakkolammi     Fixed channels being swapped
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity audio_codec_model is
  
  generic (
    data_width_g : integer := 16);

  port (
    rst_n           : in  std_logic;
    aud_data_in     : in  std_logic;
    aud_bclk_in     : in  std_logic;
    aud_lrclk_in    : in  std_logic;
    value_left_out  : out std_logic_vector(data_width_g-1 downto 0);
    value_right_out : out std_logic_vector(data_width_g-1 downto 0)
    );

end entity audio_codec_model;

architecture ac_model of audio_codec_model is

  type states_type is (wait_for_input, read_left, read_right);

  -- Previous lrclk value for edge detection
  signal aud_lrclk_prev_r : std_logic;

  -- Signals for reading inputs
  signal value_left_r  : std_logic_vector(data_width_g-1 downto 0);
  signal value_right_r : std_logic_vector(data_width_g-1 downto 0);

  -- Counters for saving bits
  signal left_counter_r  : integer;
  signal right_counter_r : integer;

  -- Outputs
  signal value_left_out_r  : std_logic_vector(data_width_g-1 downto 0);
  signal value_right_out_r : std_logic_vector(data_width_g-1 downto 0);

begin  -- architecture ac_model

  state_machine_proc : process (aud_bclk_in, rst_n) is
    variable present_state_r : states_type;

    -- Keep track of when the signal bits have been received
    variable left_completed  : boolean := false;
    variable right_completed : boolean := false;
  begin  -- process state_machine_proc
    if rst_n = '0' then                 -- asynchronous reset (active low)
      -- Initialisations
      present_state_r  := wait_for_input;
      aud_lrclk_prev_r <= '0';
      left_counter_r   <= 0;
      right_counter_r  <= 0;
      value_left_r     <= (others => '0');
      value_right_r    <= (others => '0');

    elsif aud_bclk_in'event and aud_bclk_in = '1' then  -- rising clock edge
      ---------- STATE TRANSITIONS ----------
      -- If state is wait or right and there is falling edge in lrclk
      if (present_state_r = wait_for_input or present_state_r = read_right) and
        (aud_lrclk_in = '0' and aud_lrclk_prev_r = '1') then
        present_state_r := read_left;
        left_completed  := false;
      end if;

      -- If state is left and raising edge in lrclk
      if aud_lrclk_in = '1' and aud_lrclk_prev_r = '0' then
        present_state_r := read_right;
        right_completed := false;
      end if;

      ---------- STATES ----------
      -- Note that that the current state is a variable and therefor
      -- updates immediately above
      if present_state_r = read_left then
        -- Read bit
        if left_completed = false then
          value_left_r(data_width_g-1 -left_counter_r) <= aud_data_in;
        end if;

        -- Update left data output when bits have been received
        if left_counter_r = data_width_g-1 then
          left_counter_r   <= 0;
          left_completed   := true;

          -- Note that both values are updated here so that they stay in sync
          value_right_out_r <= value_right_r;
          value_left_out_r <= value_left_r;
        else
          -- Increment counter
          left_counter_r <= left_counter_r + 1;
        end if;
        
      elsif present_state_r = read_right then
        -- Read bit
        if right_completed = false then
          value_right_r(data_width_g-1 -right_counter_r) <= aud_data_in;
        end if;
        
        -- Right counters but updating data happens in left counter cycle
        if right_counter_r = data_width_g-1 then
          right_counter_r   <= 0;
          right_completed   := true;
        else
          -- Increment counter
          right_counter_r <= right_counter_r + 1;
        end if;
      end if;

      -- Save previous bclk value
      aud_lrclk_prev_r <= aud_lrclk_in;
    end if;
  end process state_machine_proc;

  value_left_out  <= value_left_out_r;
  value_right_out <= value_right_out_r;
end architecture ac_model;
