-- VHDL Entity tb_lib.tb_register_controller.symbol
--
-- Created:
--          by - kayra.UNKNOWN (WS-11696-PC)
--          at - 11:35:45 08/24/18
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tb_register_controller IS
-- Declarations

END tb_register_controller ;

--
-- VHDL Architecture tb_lib.tb_register_controller.struct
--
-- Created:
--          by - kayra.UNKNOWN (WS-11696-PC)
--          at - 16:01:50  3.09.2020
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY tb_lib;

ARCHITECTURE struct OF tb_register_controller IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL bit_out  : std_logic;
   SIGNAL channel  : std_logic_vector(7 DOWNTO 0);
   SIGNAL clk      : std_logic;
   SIGNAL do_tx    : std_logic;
   SIGNAL lat      : std_logic;
   SIGNAL pixdata  : std_logic_vector(23 DOWNTO 0);
   SIGNAL rst_n    : std_logic;
   SIGNAL rx_ready : std_logic;
   SIGNAL xr       : std_logic_vector(7 DOWNTO 0);
   SIGNAL yr       : std_logic_vector(7 DOWNTO 0);


   -- Component Declarations
   COMPONENT register_controller_tester
   PORT (
      bit_out  : IN     std_logic ;
      channel  : IN     std_logic_vector (7 DOWNTO 0);
      do_tx    : IN     std_logic ;
      lat      : IN     std_logic ;
      x        : IN     std_logic_vector (7 DOWNTO 0);
      y        : IN     std_logic_vector (7 DOWNTO 0);
      clk      : OUT    std_logic ;
      pixdata  : OUT    std_logic_vector (23 DOWNTO 0);
      rst_n    : OUT    std_logic ;
      rx_ready : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : register_controller_tester USE ENTITY tb_lib.register_controller_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_1 : register_controller_tester
      PORT MAP (
         bit_out  => bit_out,
         channel  => channel,
         do_tx    => do_tx,
         lat      => lat,
         x        => xr,
         y        => yr,
         clk      => clk,
         pixdata  => pixdata,
         rst_n    => rst_n,
         rx_ready => rx_ready
      );

END struct;
