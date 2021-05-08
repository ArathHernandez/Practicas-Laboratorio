library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity P10 is
    Port ( clkP : in STD_LOGIC;
           resetP : in STD_LOGIC;
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           rojo : out STD_LOGIC_VECTOR (3 downto 0);
           verde : out STD_LOGIC_VECTOR (3 downto 0);
           azul : out STD_LOGIC_VECTOR (3 downto 0));
end P10;

architecture Behavioral of P10 is

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component VGA_DISP_CONTROLLER IS
  port(
    clk : IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
    reset   : IN   STD_LOGIC;  --active low asycnchronous reset
    hsync    : OUT  STD_LOGIC;  --horiztonal sync pulse
    vsync    : OUT  STD_LOGIC;  --vertical sync pulse
    video_on  : OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    pixel_x    : OUT  STD_LOGIC_VECTOR(9 downto 0);    --horizontal pixel coordinate
    pixel_y       : OUT  STD_LOGIC_VECTOR(9 downto 0)    --vertical pixel coordinate
    );
end component;

signal clock : std_logic := '0';
signal reset_aux : std_logic;
signal y_c : std_logic_vector(9 downto 0) := "0000000000";
signal x_r : std_logic_vector(9 downto 0) := "0000000000";
signal ld : std_logic;
signal ONvideo : std_logic;
   
begin
    clock_div : clk_wiz_0
       port map ( 
      -- Clock out ports  
       clk_out1 => clock,
      -- Status and control signals                
       reset => '0',
       locked => ld,
       -- Clock in ports
       clk_in1 => clkP
     );
     
vga : VGA_DISP_CONTROLLER
port map (  
clk => clock,
reset => reset_aux,
hsync => hs, 
vsync => vs,  --vertical sync pulse
video_on => ONvideo,  --display enable ('1' = display time, '0' = blanking time)
pixel_y => y_c,    --horizontal pixel coordinate
pixel_x  => x_r    --vertical pixel coordinate
);
        
process(ONvideo, x_r, y_c)
variable ws : std_logic_vector(9 downto 0) := "0000001010";
begin
    
if(ONvideo = '1') then
        
if(
( x_r >= "0000000000" and x_r <= ws) or
( x_r >= "0111010110" and x_r <= "0111100000") or
( y_c >= "0011101011" and y_c <= "0011110101") or
( x_r >= "0011101011" and x_r <= "0011110101")or
( y_c >= "0000000000" and y_c <= ws) or
( y_c >= "0111100000" and y_c <= "0111101010")
 ) then
rojo <= (others => '1');
verde  <= (others => '0');
azul <= (others => '0');  
else
rojo <= (others => '0');
verde  <= (others => '0');
azul <= (others => '1');  
end if;            
else 
rojo <= (others => '0');
verde <= (others => '0');
azul <= (others => '0');
end if;
end process;
reset_aux <= not resetP;
end Behavioral;
