-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 02
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ripple_carry_adder.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2020-11-07
-- Last update: 2020-11-07
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 3-bit ripple carry adder
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-11-07  1.0      kaakkola	Created
-------------------------------------------------------------------------------

-- TODO: Add VHDL Header here (in Emacs use: VHDL->Template->Insert Header )
--       Use your group number and name(s) of the group member(s)
--       in the 'author' field
--       Testbench has an example what a good header should look like


-- TODO: Add library called ieee here
--       And use package called std_logic_1164 from the library

library ieee;
use ieee.std_logic_1164.all;

-- TODO: Declare entity here
-- Name: ripple_carry_adder
-- No generics yet
-- Ports: a_in  3-bit std_logic_vector
--        b_in  3-bit std_logic_vector
--        s_out 4-bit std_logic_vector

entity ripple_carry_adder is
  
  port (
    a_in  : in  std_logic_vector(2 downto 0);
    b_in  : in  std_logic_vector(2 downto 0);
    s_out : out std_logic_vector(3 downto 0));

end entity ripple_carry_adder;

-------------------------------------------------------------------------------

-- Architecture called 'gate' is already defined. Just fill it.
-- Architecture defines an implementation for an entity
architecture gate of ripple_carry_adder is

  -- TODO: Add your internal signal declarations here
  signal Carry_ha, Carry_fa, C, D, E, F, G, H : std_logic;
  
begin  -- gate
  
  -- Half adder
  Carry_ha <= a_in(0) and b_in(0);
  s_out(0) <= a_in(0) xor b_in(0);

  -- Full adder #1
  C <= a_in(1) xor b_in(1);
  D <= C and Carry_ha;
  E <= a_in(1) and b_in(1);
  Carry_fa <= D or E;
  s_out(1) <= Carry_ha xor C;

  -- Full adder #2
  F <= a_in(2) xor b_in(2);
  G <= Carry_fa and F;
  H <= a_in(2) and b_in(2);
  s_out(2) <= Carry_fa xor F;
  s_out(3) <= G or H;
  
    
end gate;
