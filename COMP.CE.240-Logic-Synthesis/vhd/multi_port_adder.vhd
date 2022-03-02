-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 04
-- Project    : 
-------------------------------------------------------------------------------
-- File       : multi_port_adder.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2020-11-21
-- Last update: 2020-12-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Multi port adder
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author      	Description
-- 2020-11-22  1.0      xxx        		Created
-- 2020-12-01  1.1      Kaakkolammi     Fixex adder_3 port widths
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multi_port_adder is
  
  generic (
    operand_width_g   : integer := 16;
    num_of_operands_g : integer := 4);

  port (
    clk         : in  std_logic;
    rst_n       : in  std_logic;
    operands_in : in  std_logic_vector(operand_width_g*num_of_operands_g-1 downto 0);
    sum_out     : out std_logic_vector(operand_width_g-1 downto 0));

end entity multi_port_adder;

architecture structural of multi_port_adder is
  
  component adder is
    generic (
      operand_width_g : integer);
    port (
      clk     : in  std_logic;
      rst_n   : in  std_logic;
      a_in    : in  std_logic_vector (operand_width_g - 1 downto 0) := (others => '0');
      b_in    : in  std_logic_vector (operand_width_g - 1 downto 0) := (others => '0');
      sum_out : out std_logic_vector (operand_width_g downto 0)     := (others => '0'));
  end component adder;

  type vectorarray is array (0 to num_of_operands_g/2-1) of std_logic_vector(operand_width_g downto 0);

  signal subtotal : vectorarray;
  signal total    : std_logic_vector(operand_width_g+1 downto 0);
  
  
begin  -- architecture structural

  assert num_of_operands_g = 4 report "Operand count not 4" severity failure;

  adder_1 : entity work.adder
    generic map (
      operand_width_g => operand_width_g)
    port map (
      clk     => clk,
      rst_n   => rst_n,
      a_in    => operands_in(operand_width_g*4-1 downto operand_width_g*3),
      b_in    => operands_in(operand_width_g*3-1 downto operand_width_g*2),
      sum_out => subtotal(0));

  adder_2 : entity work.adder
    generic map (
      operand_width_g => operand_width_g)
    port map (
      clk     => clk,
      rst_n   => rst_n,
      a_in    => operands_in(operand_width_g*2-1 downto operand_width_g),
      b_in    => operands_in(operand_width_g-1 downto 0),
      sum_out => subtotal(1));

  adder_3 : entity work.adder
    generic map (
      operand_width_g => operand_width_g+1)
    port map (
      clk     => clk,
      rst_n   => rst_n,
      a_in    => subtotal(0),
      b_in    => subtotal(1),
      sum_out => total);

  sum_out <= total(operand_width_g-1 downto 0);
  
end architecture structural;
