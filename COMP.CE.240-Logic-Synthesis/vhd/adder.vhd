-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 03
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adder.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2020-11-14
-- Last update: 2020-12-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Generic adder
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author      	Description
-- 2020-11-14  1.0      xxx        		Created
-- 2020-12-01  1.1      Kaakkolammi     Design rule fixes
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is

  generic (operand_width_g : integer);

  -- Set input and output datatypes
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    a_in    : in  std_logic_vector (operand_width_g - 1 downto 0);
    b_in    : in  std_logic_vector (operand_width_g - 1 downto 0);
    sum_out : out std_logic_vector (operand_width_g downto 0));

end adder;

architecture rtl of adder is

  -- Create signal which is connected to output
  signal result_r : signed (operand_width_g downto 0);

begin
  sum_out <= std_logic_vector(result_r);

  process (clk, rst_n)
  begin
    if rst_n = '0' then
      result_r <= (others => '0');      --reset registers
    elsif clk'event and clk = '1' then
      -- Compute sum to the output at rising clock edge when reset is not active
      result_r <= resize(signed(a_in), operand_width_g +1) + resize(signed(b_in), operand_width_g +1);
    end if;
  end process;
end;
