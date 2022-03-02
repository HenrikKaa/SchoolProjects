-- VHDL Entity alien_game_lib.c3_t1_gun_pixel_decider.symbol
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop9.tuni.fi)
--          at - 15:06:00 11/23/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY c3_t1_gun_pixel_decider IS
   PORT( 
      gun_px_idx : IN     std_logic_vector (1 DOWNTO 0);
      x_in       : IN     std_logic_vector (7 DOWNTO 0);
      x_coord    : OUT    std_logic_vector (7 DOWNTO 0);
      y_coord    : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END c3_t1_gun_pixel_decider ;

--
-- VHDL Architecture alien_game_lib.c3_t1_gun_pixel_decider.struct
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop9.tuni.fi)
--          at - 15:06:00 11/23/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY alien_game_lib;

ARCHITECTURE struct OF c3_t1_gun_pixel_decider IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL dout  : std_logic_vector(7 DOWNTO 0);
   SIGNAL dout1 : std_logic_vector(7 DOWNTO 0);
   SIGNAL dout2 : std_logic_vector(7 DOWNTO 0);
   SIGNAL dout4 : std_logic_vector(7 DOWNTO 0);


   -- Component Declarations
   COMPONENT c2_t2_left_shifter
   PORT (
      data_in  : IN     std_logic_vector (7 DOWNTO 0);
      data_out : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT c2_t4_right_shifter
   PORT (
      data_in  : IN     std_logic_vector (7 DOWNTO 0);
      data_out : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : c2_t2_left_shifter USE ENTITY alien_game_lib.c2_t2_left_shifter;
   FOR ALL : c2_t4_right_shifter USE ENTITY alien_game_lib.c2_t4_right_shifter;
   -- pragma synthesis_on


BEGIN

   -- ModuleWare code(v1.12) for instance 'y_coord_1' of 'constval'
   dout <= "10000000";

   -- ModuleWare code(v1.12) for instance 'y_coord_2' of 'constval'
   dout1 <= "01000000";

   -- ModuleWare code(v1.12) for instance 'U_0' of 'mux'
   u_0combo_proc: PROCESS(x_in, dout2, dout4, gun_px_idx)
   BEGIN
      CASE gun_px_idx IS
      WHEN "00" => x_coord <= x_in;
      WHEN "01" => x_coord <= dout2;
      WHEN "10" => x_coord <= x_in;
      WHEN "11" => x_coord <= dout4;
      WHEN OTHERS => x_coord <= (OTHERS => 'X');
      END CASE;
   END PROCESS u_0combo_proc;

   -- ModuleWare code(v1.12) for instance 'U_1' of 'mux'
   u_1combo_proc: PROCESS(dout1, dout, gun_px_idx)
   BEGIN
      CASE gun_px_idx IS
      WHEN "00" => y_coord <= dout1;
      WHEN "01" => y_coord <= dout;
      WHEN "10" => y_coord <= dout;
      WHEN "11" => y_coord <= dout;
      WHEN OTHERS => y_coord <= (OTHERS => 'X');
      END CASE;
   END PROCESS u_1combo_proc;

   -- Instance port mappings.
   U_3 : c2_t2_left_shifter
      PORT MAP (
         data_in  => x_in,
         data_out => dout4
      );
   U_2 : c2_t4_right_shifter
      PORT MAP (
         data_in  => x_in,
         data_out => dout2
      );

END struct;