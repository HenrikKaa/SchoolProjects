-- VHDL Entity tb_lib.tb_register_single.symbol
--
-- Created:
--          by - kayra.UNKNOWN (linux-desktop2.tuni.fi)
--          at - 16:32:57 06/04/18
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tb_register_single IS
-- Declarations

END tb_register_single ;

--
-- VHDL Architecture tb_lib.tb_register_single.struct
--
-- Created:
--          by - palviain.palviain (linux-desktop2.tuni.fi)
--          at - 16:19:38 12/04/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY alien_game_lib;
LIBRARY tb_lib;

ARCHITECTURE struct OF tb_register_single IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk          : std_logic;
   SIGNAL nullify      : std_logic;
   SIGNAL pix_d        : std_logic_vector(23 DOWNTO 0);
   SIGNAL pix_from_duv : std_logic_vector(23 DOWNTO 0);
   SIGNAL rst_n        : std_logic;
   SIGNAL write        : std_logic;


   -- Component Declarations
   COMPONENT c7_t4_register_single
   PORT (
      clk     : IN     std_logic ;
      nullify : IN     std_logic ;
      pix_d   : IN     std_logic_vector (23 DOWNTO 0);
      rst_n   : IN     std_logic ;
      write   : IN     std_logic ;
      pix_out : OUT    std_logic_vector (23 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT register_single
   PORT (
      pix_from_duv : IN     std_logic_vector (23 DOWNTO 0);
      clk          : OUT    std_logic;
      nullify      : OUT    std_logic;
      pix_d        : OUT    std_logic_vector (23 DOWNTO 0);
      rst_n        : OUT    std_logic;
      write        : OUT    std_logic
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : c7_t4_register_single USE ENTITY alien_game_lib.c7_t4_register_single;
   FOR ALL : register_single USE ENTITY tb_lib.register_single;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_1 : c7_t4_register_single
      PORT MAP (
         clk     => clk,
         nullify => nullify,
         pix_d   => pix_d,
         rst_n   => rst_n,
         write   => write,
         pix_out => pix_from_duv
      );
   U_0 : register_single
      PORT MAP (
         clk          => clk,
         rst_n        => rst_n,
         pix_d        => pix_d,
         pix_from_duv => pix_from_duv,
         write        => write,
         nullify      => nullify
      );

END struct;
