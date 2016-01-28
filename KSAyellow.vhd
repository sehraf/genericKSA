----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2016 23:26:13
-- Design Name: 
-- Module Name: KSAyellow - Behavioral
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

entity KSAyellow is
    Port ( P_in : in STD_LOGIC;
           P_in_prev : in STD_LOGIC;
           P_out : out STD_LOGIC;
           G_in : in STD_LOGIC;
           G_in_prev : in STD_LOGIC;
           G_out : out STD_LOGIC);
end KSAyellow;

architecture Behavioral of KSAyellow is
begin

    P_out <=  P_in and P_in_prev;
    G_out <= (P_in and G_in_prev) or G_in;

end Behavioral;
