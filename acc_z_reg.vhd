library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity acc_z_reg is
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        acc_we     : in  std_logic;
        z_we       : in  std_logic;
        alu_result : in  std_logic_vector(7 downto 0);
        acc_out    : out std_logic_vector(7 downto 0);
        z_out      : out std_logic
    );
end acc_z_reg;

architecture rtl of acc_z_reg is
    signal acc_r : std_logic_vector(7 downto 0) := (others => '0');
    signal z_r   : std_logic := '1';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                acc_r <= (others => '0');
                z_r   <= '1';
            else
                if acc_we = '1' then
                    acc_r <= alu_result;
                end if;
                if z_we = '1' then
                    if alu_result = "00000000" then
                        z_r <= '1';
                    else
                        z_r <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    acc_out <= acc_r;
    z_out   <= z_r;
end rtl;