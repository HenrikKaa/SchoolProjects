-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 07
-- Project    : 
-------------------------------------------------------------------------------
-- File       : audio_ctrl.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2021-01-15
-- Last update: 2021-01-22
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Audio controller for DA7212
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-01-15  1.0      Kaakkolammi     Created
-- 2021-01-22  1.1      Kaakkolammi     Changed timings
-- 2021-01-22  1.2      Kaakkolammi     Commenting, ranges for integers
-- 2021-01-22  1.3      Kaakkolammi     Changed snapshots to raising lrclk only
-- 2021-01-24  1.4      Kaakkolammi     Fixed incorrect clock speeds
-- 2021-02-21  1.5      Kaakkolammi     Fixed WCLK timings and BCLK counting,
--                                      connected aud_data_r directly to output
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_ctrl is
  generic (
    ref_clk_freq_g : integer := 12288000;
    sample_rate_g  : integer := 48000;
    data_width_g   : integer := 16
    );

  port (
    clk           : in  std_logic;
    rst_n         : in  std_logic;
    left_data_in  : in  std_logic_vector(data_width_g-1 downto 0);
    right_data_in : in  std_logic_vector(data_width_g-1 downto 0);
    aud_bclk_out  : out std_logic;
    aud_data_out  : out std_logic;
    aud_lrclk_out : out std_logic
    );
end audio_ctrl;

architecture audio_controller of audio_ctrl is
  -- 256 with default values
  constant bclk_cycles_c  : integer := ref_clk_freq_g/(sample_rate_g * data_width_g*2)/2;
  -- 16 with default values
  constant lrclk_cycles_c : integer := data_width_g;

  -- Without explicit ranges the simulation won't work resulting
  -- error index out of range
  signal bclk_counter_r  : integer range 0 to bclk_cycles_c-1;
  signal lrclk_counter_r : integer range 0 to lrclk_cycles_c-1;

  signal left_data_r  : std_logic_vector(data_width_g-1 downto 0);
  signal right_data_r : std_logic_vector(data_width_g-1 downto 0);

  signal data_completed : std_logic;

  signal aud_bclk_r  : std_logic;
  signal aud_lrclk_r : std_logic;
  signal aud_data_r  : std_logic;

begin  -- architecture audio_controller

  process_audio : process (clk, rst_n) is
  begin  -- process process_audio
    if rst_n = '0' then                 -- asynchronous reset (active low)
      bclk_counter_r  <= 0;
      lrclk_counter_r <= 0;

      left_data_r  <= (others => '0');
      right_data_r <= (others => '0');

      data_completed <= '1';

      aud_bclk_r  <= '0';
      aud_lrclk_r <= '0';
      aud_data_r  <= '0';
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      -- Audio codec clock generation
      if bclk_counter_r = bclk_cycles_c-1 then
        aud_bclk_r     <= not aud_bclk_r;
        bclk_counter_r <= 0;
      else
        aud_bclk_r     <= aud_bclk_r;
        bclk_counter_r <= bclk_counter_r + 1;
      end if;

      -- Raising edge of aud_bclk
      if bclk_counter_r = bclk_cycles_c-1 and aud_bclk_r = '0' then
        -- Take snapshot of the audio data every raising lrclk
        if lrclk_counter_r = lrclk_cycles_c-1 and aud_lrclk_r = '0' then
          left_data_r  <= left_data_in;
          right_data_r <= right_data_in;
        end if;

        -- Send data, msb first
        -- lrclk=1 right channel, lrclk=0 left channel
        -- Right channel
        if aud_lrclk_r = '1' then
          aud_data_r <= right_data_r(data_width_g-1 -lrclk_counter_r);
        -- Left channel
        else
          aud_data_r <= left_data_r(data_width_g-1 -lrclk_counter_r);
        end if;
      end if;

      -- Falling edge of aud_bclk
      if bclk_counter_r = bclk_cycles_c-1 and aud_bclk_r = '1' then
        -- Audio coded left-right flip
        if lrclk_counter_r = lrclk_cycles_c-1 then
          aud_lrclk_r     <= not aud_lrclk_r;
          lrclk_counter_r <= 0;
        else
          aud_lrclk_r     <= aud_lrclk_r;
          lrclk_counter_r <= lrclk_counter_r + 1;
        end if;
      end if;
    end if;
  end process process_audio;

  aud_bclk_out  <= aud_bclk_r;
  aud_lrclk_out <= aud_lrclk_r;
  aud_data_out  <= aud_data_r;
end architecture audio_controller;
