-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Fri Jan 28 14:25:01 2022
-- Host        : HTC219-710-SPC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Hello_LED_led_0_0_sim_netlist.vhdl
-- Design      : Hello_LED_led_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led_core is
  port (
    return_rsc_triosy_lz : out STD_LOGIC;
    return_rsc_dat : out STD_LOGIC;
    input_rsc_dat : in STD_LOGIC;
    rst : in STD_LOGIC;
    clk : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led_core;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led_core is
  signal reg_return_rsc_triosy_obj_ld_cse_i_1_n_0 : STD_LOGIC;
  signal return_rsci_idat_i_1_n_0 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of reg_return_rsc_triosy_obj_ld_cse_i_1 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of return_rsci_idat_i_1 : label is "soft_lutpair0";
begin
reg_return_rsc_triosy_obj_ld_cse_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst,
      O => reg_return_rsc_triosy_obj_ld_cse_i_1_n_0
    );
reg_return_rsc_triosy_obj_ld_cse_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => reg_return_rsc_triosy_obj_ld_cse_i_1_n_0,
      Q => return_rsc_triosy_lz,
      R => '0'
    );
return_rsci_idat_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => input_rsc_dat,
      I1 => rst,
      O => return_rsci_idat_i_1_n_0
    );
return_rsci_idat_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => return_rsci_idat_i_1_n_0,
      Q => return_rsc_dat,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led is
  port (
    return_rsc_triosy_lz : out STD_LOGIC;
    return_rsc_dat : out STD_LOGIC;
    input_rsc_dat : in STD_LOGIC;
    rst : in STD_LOGIC;
    clk : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led is
begin
led_core_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led_core
     port map (
      clk => clk,
      input_rsc_dat => input_rsc_dat,
      return_rsc_dat => return_rsc_dat,
      return_rsc_triosy_lz => return_rsc_triosy_lz,
      rst => rst
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    input_rsc_dat : in STD_LOGIC;
    input_rsc_triosy_lz : out STD_LOGIC;
    return_rsc_dat : out STD_LOGIC;
    return_rsc_triosy_lz : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "Hello_LED_led_0_0,led,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "led,Vivado 2017.2";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \^return_rsc_triosy_lz\ : STD_LOGIC;
begin
  input_rsc_triosy_lz <= \^return_rsc_triosy_lz\;
  return_rsc_triosy_lz <= \^return_rsc_triosy_lz\;
U0: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_led
     port map (
      clk => clk,
      input_rsc_dat => input_rsc_dat,
      return_rsc_dat => return_rsc_dat,
      return_rsc_triosy_lz => \^return_rsc_triosy_lz\,
      rst => rst
    );
end STRUCTURE;
