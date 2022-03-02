-------------------------------------------------------------------------------
-- Title      : COMP.CE.240, Exercise 05
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tb_multi_port_adder.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2020-11-29
-- Last update: 2020-12-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Multi port adder test bench
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author      	Description
-- 2020-11-29  1.0      xxx        		Created
-- 2020-12-01  1.1      Kaakkolammi     Fixed shifting
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_multi_port_adder is

  generic (operand_width_g : integer := 3);

end tb_multi_port_adder;

-- Test bend architecture
architecture testbench of tb_multi_port_adder is

  constant clk_period_c      : time    := 10 ns;
  constant num_of_operands_c : integer := 4;
  constant duv_delay_c       : integer := 2;

  -- Clock and reset low signals
  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';

  -- The sizes for the first two might need to be changes
  signal operands_r     : std_logic_vector (operand_width_g*num_of_operands_c-1 downto 0);
  signal sum_r            : std_logic_vector ((operand_width_g - 1) downto 0);
  signal output_valid_r : std_logic_vector((duv_delay_c + 1 - 1) downto 0);

  -- Files
  file input_f       : text open read_mode is "input.txt";
  file ref_results_f : text open read_mode is "ref_results.txt";
  file output_f      : text open write_mode is "output.txt";

  -- Component declaration of  Design Under Verification (DUV) for multi_port_adder
  component multi_port_adder
    generic (
      operand_width_g   : integer;
      num_of_operands_g : integer
      );
    port (
      clk         : in  std_logic;
      rst_n       : in  std_logic;
      operands_in : in  std_logic_vector(operand_width_g*num_of_operands_g-1 downto 0);
      sum_out     : out std_logic_vector(operand_width_g - 1 downto 0)
      );

  end component multi_port_adder;

begin  --testbench

  -- Generate clock signal
  clk <= not clk after clk_period_c/2;

  -- Set reset off after 4 clock cycles
  rst_n <= '1' after clk_period_c * 4;

  -- THE MULTIPORT ADDER DUT IS INSTANTIATED HERE
  multi_port_adder_1 : multi_port_adder
    generic map(
      operand_width_g   => operand_width_g,
      num_of_operands_g => num_of_operands_c)

    port map(
      clk         => clk,
      rst_n       => rst_n,
      operands_in => operands_r,
      sum_out     => sum_r
      );

  -- This process reads input file and prepares the values for the adder
  input_reader : process (clk, rst_n)
    variable single_line_v : line;
    variable vals_v        : integer;

  begin  -- process input_reader
    if rst_n = '0' then                 -- If reset is active
      operands_r     <= (others => '0');
      output_valid_r <= (others => '0');

    elsif (clk'event and clk = '1') then                -- On rising clock edge
      output_valid_r(0)                        <= '1';  --Set LSB to one
      output_valid_r(duv_delay_c+1-1 downto 1) <= output_valid_r(duv_delay_c-1 downto 0);  -- Shift left for one bit to delay checker process

      if not endfile(input_f) then
        readline(input_f, single_line_v);

        for i in 0 to (num_of_operands_c - 1) loop  -- loop over values in a single line
          read(single_line_v, vals_v);

          -- Get the operands from the imput file
          operands_r(((operand_width_g - 1) + (operand_width_g) * i) downto (i * (operand_width_g))) <= std_logic_vector(to_signed(vals_v, 3));
        end loop;
      end if;
    end if;
  end process input_reader;

  -- This process checks that the summation result is correct and writes the result to output file
  checker : process (clk, rst_n)
    variable single_line_out_v : line;
    variable single_line_in_v  : line;
    variable val_computed_v    : integer;
  begin  -- process checker
    if (clk'event and clk = '1' and rst_n = '1') then  -- On rising clock edge when not reseted
      if (output_valid_r(duv_delay_c + 1 - 1) = '1') then  -- If output valid (after the first 2 clock cycles)
        if not (endfile(ref_results_f)) then  --If not last line in the file

          readline(ref_results_f, single_line_in_v);
          read(single_line_in_v, val_computed_v);  -- Get the assumed output value from the file
          assert to_integer(signed(sum_r)) = val_computed_v  -- Check if the result is correct
            report "Computed result does not match the reference result"
            severity failure;

          write(single_line_out_v, val_computed_v);  -- Write result to a line
          writeline(output_f, single_line_out_v);  -- Write the line to the output file
        else
          assert false
            report "Simulation done"
            severity failure;
        end if;
      end if;
    end if;
  end process checker;

end architecture testbench;
