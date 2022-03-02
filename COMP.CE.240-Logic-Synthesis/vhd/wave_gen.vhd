-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 06
-- Project    : Synthesizer
-------------------------------------------------------------------------------
-- File       : wave_gen.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2020-12-05
-- Last update: 2021-01-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Triangular wave generator
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-05  1.0      kaakkola        Created
-- 2021-01-09  1.1      kaakkola        Updated to follow design rules
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wave_gen is
  
  generic (
    width_g : integer;
    step_g  : integer);

  port (
    clk             : in  std_logic;
    rst_n           : in  std_logic;
    sync_clear_n_in : in  std_logic;
    value_out       : out std_logic_vector(width_g-1 downto 0));

end entity wave_gen;

architecture wave_generator of wave_gen is

  constant max_lvl_c : integer := ((2**(width_g-1)-1)/step_g)*step_g;

  signal signal_dir_r : std_logic;
  signal signal_lvl_r : signed(width_g-1 downto 0);
  
begin  -- architecture wave_generator

  -- Calculates the signal value based on the previous level and direction
  calculate_output : process (clk, rst_n) is

  begin  -- process calculate_output
    if rst_n = '0' then
      signal_dir_r <= '0';
      signal_lvl_r <= (others => '0');
    else
      if (clk'event and clk = '1') then
        if sync_clear_n_in = '0' then
          signal_dir_r <= '0';
          signal_lvl_r <= (others => '0');
        else
          -- Check if direction should be changed.
          -- The test needs to be done one step ahead or the change
          -- takes effect one cycle too late. Direction need to be
          -- tested too or the signal starts oscillating.
          if (signal_lvl_r = max_lvl_c-step_g and signal_dir_r = '0') or
             (signal_lvl_r = -max_lvl_c+step_g and signal_dir_r = '1') then
            signal_dir_r <= not signal_dir_r;
          end if;

          -- Signal goes up
          if(signal_dir_r = '0') then
            signal_lvl_r <= signal_lvl_r + step_g;
          -- Signal goes down
          else
            signal_lvl_r <= signal_lvl_r - step_g;
          end if;
        end if;
      end if;
    end if;
  end process calculate_output;

  value_out <= std_logic_vector(signal_lvl_r);

end architecture wave_generator;
