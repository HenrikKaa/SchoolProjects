-- VHDL Entity alien_game_lib.full_adder.symbol
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop7.tuni.fi)
--          at - 16:55:08 09/18/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY full_adder IS
   PORT( 
      sw0   : IN     std_logic;
      sw1   : IN     std_logic;
      sw2   : IN     std_logic;
      carry : OUT    std_logic;
      sum   : OUT    std_logic
   );

-- Declarations

END full_adder ;

--
-- VHDL Architecture alien_game_lib.full_adder.struct
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop7.tuni.fi)
--          at - 16:55:08 09/18/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY alien_game_lib;

ARCHITECTURE struct OF full_adder IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL carry1 : std_logic;
   SIGNAL din1   : std_logic;
   SIGNAL sum1   : std_logic;


   -- Component Declarations
   COMPONENT c1_t1_half_adder
   PORT (
      sw0   : IN     std_logic ;
      sw1   : IN     std_logic ;
      carry : OUT    std_logic ;
      sum   : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : c1_t1_half_adder USE ENTITY alien_game_lib.c1_t1_half_adder;
   -- pragma synthesis_on


BEGIN

   -- ModuleWare code(v1.12) for instance 'U_2' of 'or'
   carry <= carry1 OR din1;

   -- Instance port mappings.
   U_0 : c1_t1_half_adder
      PORT MAP (
         sw0   => sw1,
         sw1   => sw2,
         carry => din1,
         sum   => sum1
      );
   U_1 : c1_t1_half_adder
      PORT MAP (
         sw0   => sw0,
         sw1   => sum1,
         carry => carry1,
         sum   => sum
      );

END struct;
