-- VHDL Entity tb_lib.tb_register_64.symbol
--
-- Created:
--          by - kayra.UNKNOWN (linux-desktop13.tuni.fi)
--          at - 16:33:24 06/04/18
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tb_register_64 IS
-- Declarations

END tb_register_64 ;

--
-- VHDL Architecture tb_lib.tb_register_64.struct
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop13.tuni.fi)
--          at - 20:36:57 12/05/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY alien_game_lib;
LIBRARY tb_lib;

ARCHITECTURE struct OF tb_register_64 IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk           : std_logic;
   SIGNAL pixd          : std_logic_vector(23 DOWNTO 0);
   SIGNAL pixd_from_duv : std_logic_vector(23 DOWNTO 0);
   SIGNAL rst_n         : std_logic;
   SIGNAL w_done        : std_logic;
   SIGNAL w_ready       : std_logic;
   SIGNAL write         : std_logic;
   SIGNAL x_read        : std_logic_vector(7 DOWNTO 0);
   SIGNAL x_write       : std_logic_vector(7 DOWNTO 0);
   SIGNAL y_read        : std_logic_vector(7 DOWNTO 0);
   SIGNAL y_write       : std_logic_vector(7 DOWNTO 0);


   -- Component Declarations
   COMPONENT c7_t4_register_bank
   PORT (
      clk        : IN     std_logic ;
      frame_done : IN     std_logic ;
      pixd_in    : IN     std_logic_vector (23 DOWNTO 0);
      rst_n      : IN     std_logic ;
      write      : IN     std_logic ;
      xr         : IN     std_logic_vector (7 DOWNTO 0);
      xw         : IN     std_logic_vector (7 DOWNTO 0);
      yr         : IN     std_logic_vector (7 DOWNTO 0);
      yw         : IN     std_logic_vector (7 DOWNTO 0);
      pixd_out   : OUT    std_logic_vector (23 DOWNTO 0);
      w_rdy      : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT register_tester
   PORT (
      pixd_from_duv : IN     std_logic_vector (23 DOWNTO 0);
      w_ready       : IN     std_logic ;
      clk           : OUT    std_logic ;
      pixd          : OUT    std_logic_vector (23 DOWNTO 0);
      rst_n         : OUT    std_logic ;
      w_done        : OUT    std_logic ;
      write         : OUT    std_logic ;
      x_read        : OUT    std_logic_vector (7 DOWNTO 0);
      x_write       : OUT    std_logic_vector (7 DOWNTO 0);
      y_read        : OUT    std_logic_vector (7 DOWNTO 0);
      y_write       : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : c7_t4_register_bank USE ENTITY alien_game_lib.c7_t4_register_bank;
   FOR ALL : register_tester USE ENTITY tb_lib.register_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_1 : c7_t4_register_bank
      PORT MAP (
         clk        => clk,
         frame_done => w_done,
         pixd_in    => pixd,
         rst_n      => rst_n,
         write      => write,
         xr         => x_read,
         xw         => x_write,
         yr         => y_read,
         yw         => y_write,
         pixd_out   => pixd_from_duv,
         w_rdy      => w_ready
      );
   U_0 : register_tester
      PORT MAP (
         pixd_from_duv => pixd_from_duv,
         w_ready       => w_ready,
         clk           => clk,
         pixd          => pixd,
         rst_n         => rst_n,
         w_done        => w_done,
         write         => write,
         x_read        => x_read,
         x_write       => x_write,
         y_read        => y_read,
         y_write       => y_write
      );

END struct;