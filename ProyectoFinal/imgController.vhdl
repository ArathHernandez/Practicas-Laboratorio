library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

use work.DisplayDefinition.all;

use IEEE.NUMERIC_STD.ALL;

entity ImgCtrl is
    Port ( ck100MHz : in STD_LOGIC;    
           enaTime : in STD_LOGIC;
           weaTime : in STD_LOGIC;
           addraTime : in STD_LOGIC_VECTOR (9 downto 0);
           dinaTime : in STD_LOGIC_VECTOR (7 downto 0);
           weaFreq : in STD_LOGIC;
           addraFreq : in STD_LOGIC_VECTOR (9 downto 0);
           dinaFreq : in STD_LOGIC_VECTOR (7 downto 0);
           ckVideo : in STD_LOGIC;
           flgActiveVideo: in std_logic; 
           adrHor: in integer range 0 to cstHorSize - 1;
           adrVer: in integer range 0 to cstVerSize - 1;
		   red : out  STD_LOGIC_VECTOR (3 downto 0);
           green : out  STD_LOGIC_VECTOR (3 downto 0);
           blue : out  STD_LOGIC_VECTOR (3 downto 0));
end ImgCtrl;

architecture Behavioral of ImgCtrl is

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
ATTRIBUTE SYN_BLACK_BOX OF blk_mem_gen_0 : COMPONENT IS TRUE;
ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
ATTRIBUTE BLACK_BOX_PAD_PIN OF blk_mem_gen_0 : COMPONENT IS "clka,ena,wea[0:0],addra[9:0],dina[7:0],clkb,enb,addrb[9:0],doutb[7:0]";

  signal sampleDisplayTime: STD_LOGIC_VECTOR (7 downto 0); 
  signal sampleDisplayFreq: STD_LOGIC_VECTOR (7 downto 0);

  signal vecadrHor: std_logic_vector(9 downto 0);
  signal vecadrVer: std_logic_vector(9 downto 0);

  signal intRed: STD_LOGIC_VECTOR (3 downto 0); 
  signal intGreen: STD_LOGIC_VECTOR (3 downto 0); 
  signal intBlue: STD_LOGIC_VECTOR (3 downto 0); 
 
begin

   vecadrHor <= conv_std_logic_vector(0, 10) when adrHor = cstHorSize - 1 else
                conv_std_logic_vector(adrHor + 1, 10);
   vecadrVer <= conv_std_logic_vector(adrVer, 10);

TimeBlkMemForDisplay: blk_mem_gen_0
  PORT MAP (
    clka => ck100MHz,
    ena => enaTime,
    wea(0) => weaTime,
    addra => addraTime,
    dina => dinaTime,
    clkb => ckVideo,
    enb => '1',
    addrb => vecadrHor,
    doutb => sampleDisplayTime
  );

FreqBlkMemForDisplay: blk_mem_gen_0
  PORT MAP (
    clka => ck100MHz,
    ena => '1',
    wea(0) => weaFreq,
    addra => addraFreq,
    dina =>dinaFreq,

    clkb => ckVideo, 
    enb => '1',
    addrb => "000" & vecadrHor(9 downto 3),
    doutb => sampleDisplayFreq
  );


  intRed <= "1111" when adrVer <= cstVerAf/2 and 
                        adrVer >= cstVerAf/4 - conv_integer(sampleDisplayTime) else "0000";
  intGreen <= "1111" when
                         adrVer >= cstVerAf*47/48 - conv_integer("0" & sampleDisplayFreq(7) & sampleDisplayFreq(6 downto 0)) else "0000";
  intBlue <= "1111" when
                adrVer >= cstVerAf*47/48 - conv_integer("0" & sampleDisplayFreq(7) & sampleDisplayFreq(6 downto 0)) and 
                (adrHor/8 = 0 or adrHor/8 = 10 or adrHor/8 = 20 or adrHor/8 = 30 or adrHor/8 = 40 or adrHor/8 = 50 or adrHor/8 = 60 or adrHor/8 = 70)
        else "1111" when
                adrVer >= cstVerAf*23/48 and
                adrVer < cstVerAf*24/48 and 
                ((adrHor = 1*48) or 
                 (adrHor = 2*48) or 
                 (adrHor = 3*48) or 
                 (adrHor = 4*48) or 
                 (adrHor = 5*48) or 
                 (adrHor = 6*48) or 
                 (adrHor = 7*48) or 
                 (adrHor = 8*48) or 
                 ((adrHor >=  9*48) and 
                  (adrHor <= 10*48)) or 
                 (adrHor = 11*48) or 
                 (adrHor = 12*48) or 
                 (adrHor = 13*48))  

        else "0000";

  red <= intRed when flgActiveVideo = '1' else "0000";
  green <= intGreen when flgActiveVideo = '1' else "0000";
  blue <= intBlue when flgActiveVideo = '1' else "0000";

end Behavioral;
