library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    port (
        opcode  : in  std_logic_vector(3 downto 0);
        alu_sel : out std_logic_vector(2 downto 0);
        acc_we  : out std_logic;
        z_we    : out std_logic
    );
end control_unit;

architecture rtl of control_unit is
begin
    process(opcode)
    begin
        -- default = NOP
        alu_sel <= "000";
        acc_we  <= '0';
        z_we    <= '0';

        case opcode is
            when "0001" =>  -- LDI
                alu_sel <= "000"; acc_we <= '1'; z_we <= '1';
            when "0010" =>  -- ADD
                alu_sel <= "001"; acc_we <= '1'; z_we <= '1';
            when "0110" =>  -- XOR
                alu_sel <= "010"; acc_we <= '1'; z_we <= '1';
            when "0111" =>  -- NOT
                alu_sel <= "011"; acc_we <= '1'; z_we <= '1';
            when "1000" =>  -- SHL
                alu_sel <= "100"; acc_we <= '1'; z_we <= '1';
            when others =>  -- NOP (including 0000)
                null;
        end case;
    end process;
end rtl;