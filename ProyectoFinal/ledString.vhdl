library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_unSIGNED.ALL;

use work.DisplayDefinition.all;

use IEEE.NUMERIC_STD.ALL;
entity LedStringCtrl is
    Port ( ck100MHz: in std_logic;
           flgFreqSampleValid: in STD_LOGIC;
           addraFreq: in STD_LOGIC_VECTOR (9 downto 0);
           byteFreqSample: in STD_LOGIC_VECTOR (7 downto 0);
		   bitDataNrz : out  STD_LOGIC;
		   
		   sw: in STD_LOGIC_VECTOR (15 downto 14));
end LedStringCtrl;

architecture Behavioral of LedStringCtrl is

   signal intAddraFreq: integer range 0 to 1023;
   constant noLedInString: integer := 30;


	type mem is array ( 2**noLedInString - 1 downto 0) of std_logic_vector(23 downto 0);

   type typeLCString is array (0 to 2) of integer range 0 to 255;
   type typeLCMatrix is array (0 to noLedInString - 1) of std_logic_vector (23 downto 0);
   constant LedColorMax: typeLCMatrix := (
X"FC0000",
X"FC2A00",
X"FC5400",
X"FC7E00",
X"FCA800",
X"FCD200",
X"FCFC00",
X"D2FC00",
X"A8FC00",
X"7EFC00",
X"54FC00",
X"2AFC00",
X"00FC00",
X"00FC2A",
X"00FC54",
X"00FC7E",
X"00FCA8",
X"00FCD2",
X"00FCFC",
X"00D2FC",
X"00A8FC",
X"007EFC",
X"0054FC",
X"002AFC",
X"0000FC",
X"2A00FC",
X"5400FC",
X"7E00FC",
X"A800FC",
X"D200FC");


   signal write_en: std_logic;
   signal wordRedSample, wordGreenSample, wordBlueSample: std_logic_vector(15 downto 0);
   signal vecLedColor: std_logic_vector(23 downto 0);

   component led_controller is
   generic (N: integer;
            cstCkFrequency: real);
      Port (ckSys : in  STD_LOGIC;
            addr: integer range 0 to  N - 1;
            red: in std_logic_vector(7 downto 0);
            green: in std_logic_vector(7 downto 0);
            blue: in std_logic_vector(7 downto 0);
            write_en: in std_logic;
            cmd : out    STD_LOGIC);
   end component;
 

begin

   intAddraFreq <= conv_integer(addraFreq);

   WriteMatrix: process(intAddraFreq)
   begin
      write_en <= '0'; 
        if intAddraFreq < noLedInString then
           if flgFreqSampleValid = '1' then
              write_en <= '1'; 
           end if;
        end if;
--      end if;
   end process;           
              
	U1: led_controller
		 generic map(N => 30, 
		             cstCkFrequency => 100.0e6)
		 Port map(  ckSys	    => ck100MHz,
					addr 		=> intAddraFreq,
					red    		=> wordRedSample(15 downto 8),
					green		=> wordGreenSample(15 downto 8),
					blue		=> wordBlueSample(15 downto 8),
					write_en	=> write_en,
					  
					cmd 		=> bitDataNrz);

  selRainbow: Process(sw)
  begin
     if sw = "00" then

   wordRedSample <= byteFreqSample * LedColorMax(intAddraFreq)(23 downto 16);
   wordGreenSample <= byteFreqSample * LedColorMax(intAddraFreq)(15 downto 8);
   wordBlueSample <= byteFreqSample * LedColorMax(intAddraFreq)(7 downto 0);

elsif sw = "01" then

   wordRedSample <=LedColorMax(intAddraFreq)(23 downto 16)&x"00";
   wordGreenSample <= LedColorMax(intAddraFreq)(15 downto 8)&x"00";
   wordBlueSample <= LedColorMax(intAddraFreq)(7 downto 0)&x"00";

elsif sw = "10" then

   vecLedColor <= LedColorMax(intAddraFreq);
   wordRedSample <=vecLedColor(23 downto 16)&x"00";
   wordGreenSample <= vecLedColor(15 downto 8)&x"00";
   wordBlueSample <= vecLedColor(7 downto 0)&x"00";

elsif sw = "11" then

   vecLedColor <= x"FFFF00";
   wordRedSample <=vecLedColor(23 downto 16)&x"00";
   wordGreenSample <= vecLedColor(15 downto 8)&x"00";
   wordBlueSample <= vecLedColor(7 downto 0)&x"00";

end if;
end process;

end Behavioral;
