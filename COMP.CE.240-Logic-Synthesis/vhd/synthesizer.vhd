-------------------------------------------------------------------------------
-- Title      : COMP.CE.240 Exercise 09
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthesizer.vhd
-- Author     : Group 21, Kaakkolammi Henrik, xxx xxx
-- Company    : 
-- Created    : 2021-01-31
-- Last update: 2021-01-31
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-01-31  1.0      xxx        		Created
-- 2021-02-21  1.1      Kaakkolammi     Fixed to follow design rules
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY synthesizer IS

    GENERIC (
        clk_freq_g : INTEGER := 12288000; --Hz
        sample_rate_g : INTEGER := 48000; --Hz
        data_width_g : INTEGER := 16; --bit
        n_keys_g : INTEGER := 4
    );

    PORT (
        clk : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        keys_in : IN STD_LOGIC_VECTOR(n_keys_g - 1 DOWNTO 0);
        aud_bclk_out : OUT STD_LOGIC;
        aud_lrclk_out : OUT STD_LOGIC;
        aud_data_out : OUT STD_LOGIC
    );

END ENTITY synthesizer;

ARCHITECTURE structural OF synthesizer IS

    -- Component declarations

    COMPONENT wave_gen
        GENERIC (
            width_g : INTEGER;
            step_g : INTEGER);

        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC;
            sync_clear_n_in : IN STD_LOGIC;
            value_out : OUT STD_LOGIC_VECTOR(width_g - 1 DOWNTO 0)
        );
    END COMPONENT wave_gen;

    COMPONENT multi_port_adder
        GENERIC (
            operand_width_g : INTEGER;
            num_of_operands_g : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC;
            operands_in : IN STD_LOGIC_VECTOR(operand_width_g * num_of_operands_g - 1 DOWNTO 0);
            sum_out : OUT STD_LOGIC_VECTOR(operand_width_g - 1 DOWNTO 0)
        );
    END COMPONENT multi_port_adder;

    COMPONENT audio_ctrl
        GENERIC (
            ref_clk_freq_g : INTEGER;
            sample_rate_g : INTEGER;
            data_width_g : INTEGER
        );

        PORT (
            clk : IN STD_LOGIC;
            rst_n : IN STD_LOGIC;
            left_data_in : IN STD_LOGIC_VECTOR(data_width_g - 1 DOWNTO 0);
            right_data_in : IN STD_LOGIC_VECTOR(data_width_g - 1 DOWNTO 0);
            aud_bclk_out : OUT STD_LOGIC;
            aud_data_out : OUT STD_LOGIC;
            aud_lrclk_out : OUT STD_LOGIC
        );
    END COMPONENT audio_ctrl;

    -- Intermediate registers are declared

    -- This register contains operands for the adder. Each wavegen has its own slice where it writes
    -- its output value
    SIGNAL data_wavegens_mpa : STD_LOGIC_VECTOR (data_width_g * n_keys_g - 1 DOWNTO 0);

    -- Signal between the multi_port adder and the audio_ctrl block
    SIGNAL data_mpa_actrl : STD_LOGIC_VECTOR (data_width_g - 1 DOWNTO 0);

BEGIN -- architecture synthesizer

    wave_gen_1 : wave_gen
    GENERIC MAP(
        width_g => data_width_g,
        step_g => 1)

    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        sync_clear_n_in => keys_in(0),
        value_out => data_wavegens_mpa(data_width_g - 1 DOWNTO 0)
    );

    wave_gen_2 : wave_gen
    GENERIC MAP(
        width_g => data_width_g,
        step_g => 2)

    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        sync_clear_n_in => keys_in(1),
        value_out => data_wavegens_mpa(data_width_g * 2 - 1 DOWNTO data_width_g)
    );

    wave_gen_3 : wave_gen
    GENERIC MAP(
        width_g => data_width_g,
        step_g => 4)

    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        sync_clear_n_in => keys_in(2),
        value_out => data_wavegens_mpa(data_width_g * 3 - 1 DOWNTO data_width_g * 2)
    );

    wave_gen_4 : wave_gen
    GENERIC MAP(
        width_g => data_width_g,
        step_g => 8)

    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        sync_clear_n_in => keys_in(3),
        value_out => data_wavegens_mpa(data_width_g * 4 - 1 DOWNTO data_width_g * 3)
    );

    multi_port_adder_1 : multi_port_adder
    GENERIC MAP(
        operand_width_g => data_width_g,
        num_of_operands_g => n_keys_g)

    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        operands_in => data_wavegens_mpa,
        sum_out => data_mpa_actrl
    );

    audio_ctrl_1 : audio_ctrl
    GENERIC MAP(
        ref_clk_freq_g => clk_freq_g,
        sample_rate_g => sample_rate_g,
        data_width_g => data_width_g
    )

    PORT MAP(
        clk => clk,
        rst_n => rst_n,
        left_data_in => data_mpa_actrl,
        right_data_in => data_mpa_actrl,
        aud_bclk_out => aud_bclk_out,
        aud_data_out => aud_data_out,
        aud_lrclk_out => aud_lrclk_out
    );

END ARCHITECTURE structural;