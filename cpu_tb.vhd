library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_tb is
end cpu_tb;

architecture sim of cpu_tb is
    signal CLK   : std_logic := '0';
    signal RESET : std_logic := '1';
    signal Q     : std_logic_vector(7 downto 0);
    signal Z     : std_logic;
    signal PC    : std_logic_vector(3 downto 0);
    signal done  : boolean := false;
begin
    DUT : entity work.cpu_top
        port map (CLK => CLK, RESET => RESET, Q => Q, Z => Z, PC => PC);

    -- clock: 10 ns period
    clk_proc : process
    begin
        while not done loop
            CLK <= '0'; wait for 5 ns;
            CLK <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process;

    stim : process
        procedure check(exp_q : std_logic_vector(7 downto 0);
                        exp_z : std_logic;
                        exp_pc: std_logic_vector(3 downto 0);
                        name  : string) is
        begin
            wait until rising_edge(CLK);
            wait for 1 ns;
            assert (Q = exp_q and Z = exp_z and PC = exp_pc)
                report "MISMATCH after " & name severity error;
        end procedure;
    begin
        -- RESET for exactly one rising edge
        RESET <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert (Q = x"00" and Z = '1' and PC = x"0")
            report "RESET failed" severity error;
        RESET <= '0';

        check(x"55", '0', x"1", "LDI 0x55");
        check(x"AA", '0', x"2", "XOR 0xFF");
        check(x"55", '0', x"3", "NOT");
        check(x"AA", '0', x"4", "SHL");
        check(x"00", '1', x"5", "ADD 0x56");
        check(x"81", '0', x"6", "XOR 0x81");
        check(x"02", '0', x"7", "SHL");

        wait for 20 ns;
        report "Simulation finished" severity note;
        done <= true;
        wait;
    end process;
end sim;