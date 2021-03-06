-- VHDL Entity tb_lib.tb_top.symbol
--
-- Created:
--          by - kayra.UNKNOWN (linux-desktop2.tuni.fi)
--          at - 11:31:10 05/31/18
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tb_top IS
-- Declarations

END tb_top ;

--
-- VHDL Architecture tb_lib.tb_top.struct
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop2.tuni.fi)
--          at - 11:12:57 12/04/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY alien_game_lib;
LIBRARY tb_lib;

ARCHITECTURE struct OF tb_top IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL btn       : std_logic_vector(3 DOWNTO 0);
   SIGNAL channel   : std_logic_vector(7 DOWNTO 0);
   SIGNAL clk       : std_logic;
   SIGNAL data_out  : std_logic_vector(7 DOWNTO 0);
   SIGNAL gamma_out : std_logic_vector(5 DOWNTO 0);
   SIGNAL lat       : std_logic;
   SIGNAL rst_n     : std_logic;
   SIGNAL s_clk     : std_logic;
   SIGNAL s_rst     : std_logic;
   SIGNAL s_sda     : std_logic;
   SIGNAL sb        : std_logic;
   SIGNAL sw0       : std_logic;


   -- Component Declarations
   COMPONENT alien_game_top
   PORT (
      btn            : IN     std_logic_vector (3 DOWNTO 0);
      clk            : IN     std_logic ;
      rst_n          : IN     std_logic ;
      if_you_name    : OUT    std_logic_vector (7 DOWNTO 0);
      iotre_will     : OUT    std_logic ;
      like_this      : OUT    std_logic ;
      of_this_course : OUT    std_logic ;
      throw_you_out  : OUT    std_logic ;
      your_signals   : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT serial_to_bus_block
   PORT (
      clk       : IN     std_logic;
      rst_n     : IN     std_logic;
      sb        : IN     std_logic;
      sck       : IN     std_logic;
      sda       : IN     std_logic;
      data_out  : OUT    std_logic_vector (7 DOWNTO 0);
      gamma_out : OUT    std_logic_vector (5 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT top_block
   PORT (
      channel : IN     std_logic_vector (7 DOWNTO 0);
      lat     : IN     std_logic;
      s_rst   : IN     std_logic;
      sb      : IN     std_logic;
      btn     : OUT    std_logic_vector (3 DOWNTO 0);
      clk     : OUT    std_logic;
      rst_n   : OUT    std_logic;
      sw0     : OUT    std_logic
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : alien_game_top USE ENTITY alien_game_lib.alien_game_top;
   FOR ALL : serial_to_bus_block USE ENTITY tb_lib.serial_to_bus_block;
   FOR ALL : top_block USE ENTITY tb_lib.top_block;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_0 : alien_game_top
      PORT MAP (
         btn            => btn,
         clk            => clk,
         rst_n          => rst_n,
         if_you_name    => OPEN,
         iotre_will     => OPEN,
         like_this      => OPEN,
         of_this_course => OPEN,
         throw_you_out  => OPEN,
         your_signals   => OPEN
      );
   U_2 : serial_to_bus_block
      PORT MAP (
         clk       => clk,
         rst_n     => rst_n,
         sb        => sb,
         sck       => s_clk,
         sda       => s_sda,
         data_out  => data_out,
         gamma_out => gamma_out
      );
   U_1 : top_block
      PORT MAP (
         channel => channel,
         s_rst   => s_rst,
         sb      => sb,
         btn     => btn,
         clk     => clk,
         rst_n   => rst_n,
         sw0     => sw0,
         lat     => lat
      );

END struct;
