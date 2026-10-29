library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_rom is
    port (
        addr : in  std_logic_vector(3 downto 0);
        data : out std_logic_vector(11 downto 0)
    );
end program_rom;

architecture rtl of program_rom is
    type rom_t is array (0 to 15) of std_logic_vector(11 downto 0);
    constant ROM : rom_t := (
        0 => x"155",  -- LDI 0x55
        1 => x"6FF",  -- XOR 0xFF
        2 => x"700",  -- NOT
        3 => x"800",  -- SHL
        4 => x"256",  -- ADD 0x56
        5 => x"681",  -- XOR 0x81
        6 => x"800",  -- SHL
        others => x"000"  -- NOP
    );
begin
    data <= ROM(to_integer(unsigned(addr)));
end rtl;