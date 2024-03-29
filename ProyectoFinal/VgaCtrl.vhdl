library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.DisplayDefinition.all;

entity VgaCtrl is

    Port ( ckVideo : in  STD_LOGIC;
           adrHor: out integer range 0 to cstHorSize - 1;
           adrVer: out integer range 0 to cstVerSize - 1;
		   flgActiveVideo: out std_logic;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC);
end VgaCtrl;

architecture Behavioral of VgaCtrl is
 
  signal cntHor: integer range 0 to cstHorSize - 1;
  signal cntVer: integer range 0 to cstVerSize - 1;
  
  signal inHS: std_logic;
  signal inVS: std_logic;
  
  signal inAl, inAf: std_logic;

begin

  HorCounter: process(ckVideo)
  begin
    if ckVideo'event and ckVideo = '1' then
	   if cntHor = cstHorSize - 1 then
		  cntHor <= 0;
		else
		  cntHor <= cntHor + 1;
		end if;
	 end if;
  end process;

  HorSync: process(ckVideo)
  begin
    if ckVideo'event and ckVideo = '1' then
	   if cntHor = cstHorAl + cstHorFp - 1 then
		  inHS <= '0';
	   elsif cntHor = cstHorAl + cstHorFp + cstHorPw - 1 then
		  inHS <= '1';
		end if;
	 end if;
  end process;

  ActiveLine: process(ckVideo)
  begin
    if ckVideo'event and ckVideo = '1' then
	   if cntHor = cstHorSize - 1 then
		  inAl <= '1';
	   elsif cntHor = cstHorAl - 1 then
		  inAl <= '0';
		end if;
	 end if;
  end process;

  VerCounter: process(inHS)
  begin
    if inHS'event and inHS = '1' then
	   if cntVer = cstVerSize - 1 then
		  cntVer <= 0;
		else
		  cntVer <= cntVer + 1;
		end if;
	 end if;
  end process;

  VerSync: process(inHS)
  begin
    if inHS'event and inHS = '1' then
	   if cntVer = cstVerAf + cstVerFp - 1 then
		  inVS <= '0';
	   elsif cntVer = cstVerAf + cstVerFp + cstVerPw - 1 then
		  inVS <= '1';
		end if;
	 end if;
  end process;
  
  ActiveFrame: process(inHS)
  begin
    if inHS'event and inHS = '1' then
	   if cntVer = cstVerSize - 1 then
		  inAf <= '1';
	   elsif cntVer = cstVerAf - 1 then
		  inAf <= '0';
		end if;
	 end if;
  end process;

  VS <= inVS;
  HS <= inHS;
  
  flgActiveVideo <= inAl and inAf;
  
  adrHor <= cntHor;
  adrVer <= cntVer;

end Behavioral;
