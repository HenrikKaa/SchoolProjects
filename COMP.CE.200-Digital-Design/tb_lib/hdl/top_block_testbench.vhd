--
-- VHDL Architecture tb_lib.top_block.testbench
--
-- Created:
--          by - kayra.UNKNOWN (WS-11696-PC)
--          at - 10:48:36  9.08.2018
--
-- using Mentor Graphics HDL Designer(TM) 2012.2a (Build 3)
----
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY top_block IS
   PORT( 
      channel   : IN     std_logic_vector (7 DOWNTO 0);
      s_rst     : IN     std_logic;
      sb        : IN     std_logic;
      btn       : OUT    std_logic_vector (3 DOWNTO 0);
      clk       : OUT    std_logic;
      rst_n     : OUT    std_logic;
      sw0       : OUT    std_logic;
      lat : in std_logic
   );

-- Declarations

END top_block ;

--
ARCHITECTURE testbench OF top_block IS
  constant clk_period : time := 20 ns;
  
  signal clk_tb : std_logic:='0';
  signal rst_n_tb : std_logic:='0';
	signal channel_tb : std_logic_vector (7 downto 0):=(others=>'0');
	signal sb_tb : std_logic:='0';
  signal btn_tb : std_logic_vector (3 downto 0):="0000";
  signal sw_tb :std_logic:='0';
  
  signal data_tb : std_logic_vector (7 downto 0):=(others=>'0');
  signal gamma_tb : std_logic_vector (5 downto 0):=(others=>'0');
BEGIN
  
	--outputs
	clk <= clk_tb;
	rst_n <= rst_n_tb;
	btn<= btn_tb;
	sw0<= sw_tb;
	
	--inputs
	sb_tb <= sb;
  channel_tb<= channel;
   		
	-- testbench signal assignments
	clk_tb <= not clk_tb after clk_period/2;
	rst_n_tb <= '1' after 2*clk_period;
		
  -- assertions for event monitoring
  
  --gamma
  assert (sb_tb /= '1') report "gamma has been set" severity note;
  
  --channel activations
  assert (channel_tb(0)/= '1') report "channel 0 set" severity note;
  assert (channel_tb(1)/= '1') report "channel 1 set" severity note;
  assert (channel_tb(2)/= '1') report "channel 2 set" severity note;
  assert (channel_tb(3)/= '1') report "channel 3 set" severity note;
  assert (channel_tb(4)/= '1') report "channel 4 set" severity note;
  assert (channel_tb(5)/= '1') report "channel 5 set" severity note;
  assert (channel_tb(6)/= '1') report "channel 6 set" severity note;
  assert (channel_tb(7)/= '1') report "channel 7 set" severity note;
  
END ARCHITECTURE testbench;

