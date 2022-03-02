-- VHDL Entity pre_made.prand_gen.symbol
--
-- Created:
--          by - kayra.UNKNOWN (linux-desktop10.tuni.fi)
--          at - 13:41:05 09/12/19
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY prand_gen IS
   PORT( 
      clk   : IN     std_logic;
      rst_n : IN     std_logic;
      prand : OUT    std_logic
   );

-- Declarations

END prand_gen ;

--
-- VHDL Architecture pre_made.prand_gen.struct
--
-- Created:
--          by - kayra.UNKNOWN (linux-desktop10.tuni.fi)
--          at - 13:41:05 09/12/19
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2019.3 (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;


ARCHITECTURE struct OF prand_gen IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL q               : std_logic;
   SIGNAL q1              : std_logic;
   SIGNAL q2              : std_logic;
   SIGNAL q3              : std_logic;
   SIGNAL q4              : std_logic;
   SIGNAL q5              : std_logic;
   SIGNAL q6              : std_logic;
   SIGNAL q7              : std_logic;
   SIGNAL xor_8_to_xor_9  : std_logic;
   SIGNAL xor_9_to_xor_10 : std_logic;
   SIGNAL xor_to_dff      : std_logic;


   -- ModuleWare signal declarations(v1.12) for instance 'U_0' of 'adff'
   SIGNAL mw_U_0reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_1' of 'adff'
   SIGNAL mw_U_1reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_2' of 'adff'
   SIGNAL mw_U_2reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_3' of 'adff'
   SIGNAL mw_U_3reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_4' of 'adff'
   SIGNAL mw_U_4reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_5' of 'adff'
   SIGNAL mw_U_5reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_6' of 'adff'
   SIGNAL mw_U_6reg_cval : std_logic;

   -- ModuleWare signal declarations(v1.12) for instance 'U_7' of 'adff'
   SIGNAL mw_U_7reg_cval : std_logic;


BEGIN

   -- ModuleWare code(v1.12) for instance 'U_0' of 'adff'
   q <= mw_U_0reg_cval;
   u_0seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_0reg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_0reg_cval <= xor_to_dff;
      END IF;
   END PROCESS u_0seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_1' of 'adff'
   q1 <= mw_U_1reg_cval;
   u_1seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_1reg_cval <= '1';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_1reg_cval <= q;
      END IF;
   END PROCESS u_1seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_2' of 'adff'
   q2 <= mw_U_2reg_cval;
   u_2seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_2reg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_2reg_cval <= q1;
      END IF;
   END PROCESS u_2seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_3' of 'adff'
   q3 <= mw_U_3reg_cval;
   u_3seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_3reg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_3reg_cval <= q2;
      END IF;
   END PROCESS u_3seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_4' of 'adff'
   q4 <= mw_U_4reg_cval;
   u_4seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_4reg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_4reg_cval <= q3;
      END IF;
   END PROCESS u_4seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_5' of 'adff'
   q5 <= mw_U_5reg_cval;
   u_5seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_5reg_cval <= '1';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_5reg_cval <= q4;
      END IF;
   END PROCESS u_5seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_6' of 'adff'
   q6 <= mw_U_6reg_cval;
   u_6seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_6reg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_6reg_cval <= q5;
      END IF;
   END PROCESS u_6seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_7' of 'adff'
   q7 <= mw_U_7reg_cval;
   u_7seq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_U_7reg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_U_7reg_cval <= q6;
      END IF;
   END PROCESS u_7seq_proc;

   -- ModuleWare code(v1.12) for instance 'U_11' of 'buff'
   prand <= q7;

   -- ModuleWare code(v1.12) for instance 'U_8' of 'xor'
   xor_8_to_xor_9 <= q5 XOR q7;

   -- ModuleWare code(v1.12) for instance 'U_9' of 'xor'
   xor_9_to_xor_10 <= q4 XOR xor_8_to_xor_9;

   -- ModuleWare code(v1.12) for instance 'U_10' of 'xor'
   xor_to_dff <= q3 XOR xor_9_to_xor_10;

   -- Instance port mappings.

END struct;
