----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.01.2016 10:58:58
-- Design Name: 
-- Module Name: genericKoggeStoneAdder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity genericKoggeStoneAdder is
    -- defines the input/output width (width = 2 ^ depth)
    Generic ( DEPTH     : positive := 1);
    Port ( A            : in  STD_LOGIC_VECTOR (2**DEPTH-1 downto 0);
           B            : in  STD_LOGIC_VECTOR (2**DEPTH-1 downto 0);
           CARRY_IN     : in  STD_LOGIC;
           S            : out STD_LOGIC_VECTOR (2**DEPTH-1 downto 0);
           CARRY_OUT    : out STD_LOGIC);
end genericKoggeStoneAdder;

architecture Behavioral of genericKoggeStoneAdder is

    component KSAgreen is
        Port ( P_in  : in  STD_LOGIC;
               P_out : out STD_LOGIC;
               G_in  : in  STD_LOGIC;
               G_out : out STD_LOGIC);
    end component;
    
    component KSAyellow is
        Port ( P_in      : in  STD_LOGIC;
               P_in_prev : in  STD_LOGIC;
               P_out     : out STD_LOGIC;
               G_in      : in  STD_LOGIC;
               G_in_prev : in  STD_LOGIC;
               G_out     : out STD_LOGIC);
    end component;
    
    component KSAred is
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               P : out STD_LOGIC;
               G : out STD_LOGIC);
    end component;
    
    -- 0 based
    function posToIndex( row : natural; col : natural)
    return natural is begin
        return 2**DEPTH * row + col;
    end posToIndex;
    
    signal P, G : STD_LOGIC_VECTOR (2**DEPTH * DEPTH downto 0);

begin
    
    -- outer loop: iterate over columns (lsb -> msb)
    outer : for col in 0 to 2**DEPTH-1 generate
        -- first row: red
        one : KSAred port map (A(col), B(col), P(posToIndex(0, col)), G(posToIndex(0, col)));
        -- inner loop: iterate over rows
        inner : for row in 1 to DEPTH-1 generate
            -- green component
            green  : if (col <  2**(row-1)) generate 
                twoG1 : KSAgreen  port map(P(posToIndex(row-1, col)),
                                           P(posToIndex(row  , col)),
                                           G(posToIndex(row-1, col)),
                                           G(posToIndex(row  , col)));
            end generate;
            -- yellow component
            yellow : if (col >= 2**(row-1)) generate 
                twoY1 : KSAyellow port map(P(posToIndex(row-1, col)), P(posToIndex(row-1, col - 2**(row-1))),
                                           P(posToIndex(row  , col)),
                                           G(posToIndex(row-1, col)), G(posToIndex(row-1, col - 2**(row-1))),
                                           G(posToIndex(row  , col)));
            end generate;
        end generate;
        -- S
        a : if (col <  1) generate S(col) <= P(posToIndex(0, col)) xor CARRY_IN; end generate; 
        b : if (col >= 1) generate S(col) <= P(posToIndex(0, col)) xor G(posToIndex(DEPTH-1, col-1)); end generate;
    end generate;
    -- carry
    CARRY_OUT    <= G(posToIndex(DEPTH-1, 2**DEPTH-1));
end Behavioral;
