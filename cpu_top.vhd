library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_top is
    port (
        CLK   : in  std_logic;
        RESET : in  std_logic;
        Q     : out std_logic_vector(7 downto 0);  -- ACC
        Z     : out std_logic;
        PC    : out std_logic_vector(3 downto 0)
    );
end cpu_top;

architecture structural of cpu_top is
    signal pc_s    : std_logic_vector(3 downto 0);
    signal instr   : std_logic_vector(11 downto 0);
    signal alu_sel : std_logic_vector(2 downto 0);
    signal acc_we  : std_logic;
    signal z_we    : std_logic;
    signal result  : std_logic_vector(7 downto 0);
    signal acc_s   : std_logic_vector(7 downto 0);
begin
    U_PC : entity work.pc_counter
        port map (clk => CLK, reset => RESET, pc_out => pc_s);

    U_ROM : entity work.program_rom
        port map (addr => pc_s, data => instr);

    U_CU : entity work.control_unit
        port map (opcode => instr(11 downto 8),
                  alu_sel => alu_sel, acc_we => acc_we, z_we => z_we);

    U_ALU : entity work.alu
        port map (acc => acc_s, operand => instr(7 downto 0),
                  sel => alu_sel, result => result);

    U_REG : entity work.acc_z_reg
        port map (clk => CLK, reset => RESET, acc_we => acc_we, z_we => z_we,
                  alu_result => result, acc_out => acc_s, z_out => Z);

    Q  <= acc_s;
    PC <= pc_s;
end structural;