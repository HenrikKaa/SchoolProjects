-- VHDL Entity alien_game_lib.c7_t1_shield_init_reset.symbol
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop2.tuni.fi)
--          at - 11:46:26 12/04/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY c7_t1_shield_init_reset IS
   PORT( 
      clk   : IN     std_logic;
      rst_n : IN     std_logic;
      done  : OUT    std_logic;
      s_rst : OUT    std_logic
   );

-- Declarations

END c7_t1_shield_init_reset ;

--
-- VHDL Architecture alien_game_lib.c7_t1_shield_init_reset.fsm
--
-- Created:
--          by - kaakkola.kaakkola (linux-desktop2.tuni.fi)
--          at - 11:51:41 12/04/20
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF c7_t1_shield_init_reset IS

   TYPE STATE_TYPE IS (
      init,
      wait_200,
      s0,
      s1
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(3 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(3 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_wait_200 : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL done_cld : std_logic ;
   SIGNAL s_rst_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk,
      rst_n
   )
   -----------------------------------------------------------------
   BEGIN
      IF (rst_n = '0') THEN
         current_state <= init;
         csm_timer <= (OTHERS => '0');
         -- Default Reset Values
         done_cld <= '0';
         s_rst_cld <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         current_state <= next_state;
         csm_timer <= csm_next_timer;
         -- Default Assignment To Internals
         done_cld <= '0';
         s_rst_cld <= '0';

         -- Combined Actions
         CASE current_state IS
            WHEN wait_200 => 
               s_rst_cld <= '0';
            WHEN s0 => 
               s_rst_cld <= '1';
            WHEN s1 => 
               done_cld <= '1';
               s_rst_cld <= '1';
            WHEN OTHERS =>
               NULL;
         END CASE;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      csm_timeout,
      current_state,
      rst_n
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_wait_200 <= '0';
      CASE current_state IS
         WHEN init => 
            IF (rst_n = '1') THEN 
               next_state <= wait_200;
               csm_to_wait_200 <= '1';
            ELSE
               next_state <= init;
            END IF;
         WHEN wait_200 => 
            IF (csm_timeout = '1') THEN 
               next_state <= s0;
            ELSE
               next_state <= wait_200;
            END IF;
         WHEN s0 => 
            next_state <= s1;
         WHEN s1 => 
            next_state <= s1;
         WHEN OTHERS =>
            next_state <= init;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_wait_200
   )
   -----------------------------------------------------------------
   VARIABLE csm_temp_timeout : std_logic;
   BEGIN
      IF (unsigned(csm_timer) = 0) THEN
         csm_temp_timeout := '1';
      ELSE
         csm_temp_timeout := '0';
      END IF;

      IF (csm_to_wait_200 = '1') THEN
         csm_next_timer <= "1001"; -- no cycles(10)-1=9
      ELSE
         IF (csm_temp_timeout = '1') THEN
            csm_next_timer <= (OTHERS=>'0');
         ELSE
            csm_next_timer <= unsigned(csm_timer) - '1';
         END IF;
      END IF;
      csm_timeout <= csm_temp_timeout;
   END PROCESS csm_wait_combo_proc;

   -- Concurrent Statements
   -- Clocked output assignments
   done <= done_cld;
   s_rst <= s_rst_cld;
END fsm;
