-- VHDL Entity alien_game_lib.c3_t1_gun_move.symbol
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop1.tuni.fi)
--          at - 13:06:29 10/09/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY c3_t1_gun_move IS
   PORT( 
      btn     : IN     std_logic_vector (3 DOWNTO 0);
      x_place : IN     std_logic_vector (7 DOWNTO 0);
      x_coord : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END c3_t1_gun_move ;

--
-- VHDL Architecture alien_game_lib.c3_t1_gun_move.struct
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop3.tuni.fi)
--          at - 02:38:55 11/23/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY alien_game_lib;

ARCHITECTURE struct OF c3_t1_gun_move IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL data_out  : std_logic_vector(7 DOWNTO 0);
   SIGNAL data_out1 : std_logic_vector(7 DOWNTO 0);
   SIGNAL dout      : std_logic;
   SIGNAL dout1     : std_logic_vector(1 DOWNTO 0);


   -- Component Declarations
   COMPONENT left_shifter_overflow
   PORT (
      data_in  : IN     std_logic_vector (7 DOWNTO 0);
      data_out : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT right_shifter_overflow
   PORT (
      data_in  : IN     std_logic_vector (7 DOWNTO 0);
      data_out : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : left_shifter_overflow USE ENTITY alien_game_lib.left_shifter_overflow;
   FOR ALL : right_shifter_overflow USE ENTITY alien_game_lib.right_shifter_overflow;
   -- pragma synthesis_on


BEGIN

   -- ModuleWare code(v1.12) for instance 'U_5' of 'merge'
   dout1 <= btn(1) & dout;

   -- ModuleWare code(v1.12) for instance 'U_4' of 'mux'
   u_4combo_proc: PROCESS(x_place, data_out, data_out1, dout1)
   BEGIN
      CASE dout1 IS
      WHEN "00" => x_coord <= x_place;
      WHEN "01" => x_coord <= data_out;
      WHEN "10" => x_coord <= x_place;
      WHEN "11" => x_coord <= data_out1;
      WHEN OTHERS => x_coord <= (OTHERS => 'X');
      END CASE;
   END PROCESS u_4combo_proc;

   -- ModuleWare code(v1.12) for instance 'U_0' of 'xor'
   dout <= btn(3) XOR btn(1);

   -- Instance port mappings.
   U_1 : left_shifter_overflow
      PORT MAP (
         data_in  => x_place,
         data_out => data_out1
      );
   U_2 : right_shifter_overflow
      PORT MAP (
         data_in  => x_place,
         data_out => data_out
      );

END struct;
