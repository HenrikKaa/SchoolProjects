-- VHDL Entity pre_made.HELLO_DEBUG.symbol
--
-- Created:
--          by - kayra.UNKNOWN (WS-11696-PC)
--          at - 09:35:44 07/17/18
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.2a (Build 3)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY HELLO_DEBUG IS
   PORT( 
      btn            : IN     std_logic_vector (3 DOWNTO 0);
      clk            : IN     std_logic;
      rst_n          : IN     std_logic;
      if_you_name    : OUT    std_logic_vector (7 DOWNTO 0);
      iotre_will     : OUT    std_logic;
      like_this      : OUT    std_logic;
      of_this_course : OUT    std_logic;
      throw_you_out  : OUT    std_logic;
      your_signals   : OUT    std_logic
   );

-- Declarations

END HELLO_DEBUG ;

--
-- VHDL Architecture pre_made.HELLO_DEBUG.struct
--
-- Created:
--          by - kayra.UNKNOWN (WS-11696-PC)
--          at - 09:35:44 07/17/18
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.2a (Build 3)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY pre_made;

ARCHITECTURE struct OF HELLO_DEBUG IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL dout    : std_logic_vector(23 DOWNTO 0);
   SIGNAL q       : std_logic;
   SIGNAL w_rdy   : std_logic;
   SIGNAL write   : std_logic;
   SIGNAL x_coord : std_logic_vector(7 DOWNTO 0);
   SIGNAL y_coord : std_logic_vector(7 DOWNTO 0);


   -- ModuleWare signal declarations(v1.12) for instance 'convenience_ff' of 'adff'
   SIGNAL mw_convenience_ffreg_cval : std_logic;

   -- Component Declarations
   COMPONENT broken_paddle
   PORT (
      btn     : IN     std_logic_vector (3 DOWNTO 0);
      clk     : IN     std_logic ;
      rst_n   : IN     std_logic ;
      w_rdy   : IN     std_logic ;
      write   : OUT    std_logic ;
      x_coord : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT z_black_box_y
   PORT (
      clk            : IN     std_logic;
      color_BGR      : IN     std_logic_vector (23 DOWNTO 0);
      frame_done     : IN     std_logic;
      rst_n          : IN     std_logic;
      write          : IN     std_logic;
      x_coord        : IN     std_logic_vector (7 DOWNTO 0);
      y_coord        : IN     std_logic_vector (7 DOWNTO 0);
      if_you_name    : OUT    std_logic_vector (7 DOWNTO 0);
      iotre_will     : OUT    std_logic;
      like_this      : OUT    std_logic;
      of_this_course : OUT    std_logic;
      throw_you_out  : OUT    std_logic;
      w_rdy          : OUT    std_logic;
      your_signals   : OUT    std_logic
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : broken_paddle USE ENTITY pre_made.broken_paddle;
   FOR ALL : z_black_box_y USE ENTITY pre_made.z_black_box_y;
   -- pragma synthesis_on


BEGIN

   -- ModuleWare code(v1.12) for instance 'convenience_ff' of 'adff'
   q <= mw_convenience_ffreg_cval;
   convenience_ffseq_proc: PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         mw_convenience_ffreg_cval <= '0';
      ELSIF (clk'EVENT AND clk='1') THEN
         mw_convenience_ffreg_cval <= write;
      END IF;
   END PROCESS convenience_ffseq_proc;

   -- ModuleWare code(v1.12) for instance 'Y' of 'constval'
   y_coord <= "01000000";

   -- ModuleWare code(v1.12) for instance 'paddle_color' of 'constval'
   dout <= "000101110010110110001000";

   -- Instance port mappings.
   U_1 : broken_paddle
      PORT MAP (
         btn     => btn,
         clk     => clk,
         rst_n   => rst_n,
         w_rdy   => w_rdy,
         write   => write,
         x_coord => x_coord
      );
   U_0 : z_black_box_y
      PORT MAP (
         clk            => clk,
         color_BGR      => dout,
         frame_done     => q,
         rst_n          => rst_n,
         write          => write,
         x_coord        => x_coord,
         y_coord        => y_coord,
         if_you_name    => if_you_name,
         iotre_will     => iotre_will,
         like_this      => like_this,
         of_this_course => of_this_course,
         throw_you_out  => throw_you_out,
         w_rdy          => w_rdy,
         your_signals   => your_signals
      );

END struct;
