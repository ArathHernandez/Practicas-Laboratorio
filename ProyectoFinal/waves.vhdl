library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.DisplayDefinition.all;
library UNISIM;
use UNISIM.VComponents.all;

entity TopNexys4Spectral is
    Port ( ck100MHz : in STD_LOGIC;
           micData : in STD_LOGIC;
           micClk: inout STD_LOGIC;
           micLRSel: out STD_LOGIC;
           vgaRed : out  STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out  STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out  STD_LOGIC_VECTOR (3 downto 0);
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           pdm_data_o  : out std_logic;
           pdm_en_o    : out std_logic;
           bitDataNrz : out  std_logic;
           sw: in std_logic_vector(15 downto 0)
           );
end TopNexys4Spectral;

architecture Behavioral of TopNexys4Spectral is

   signal wordTimeSample: std_logic_vector(15 downto 0);
   signal flgTimeSampleValid: std_logic;
   signal flgTimeFrameActive: std_logic;
   signal addraTime: std_logic_vector(9 downto 0); 

   signal byteFreqSample: std_logic_vector(7 downto 0);
   signal flgFreqSampleValid: std_logic;
   signal addraFreq: std_logic_vector(9 downto 0);
  signal ck25MHz: std_logic;
  signal flgActiveVideo: std_logic;
  signal adrHor: integer range 0 to cstHorSize - 1;
  signal adrVer: integer range 0 to cstVerSize - 1;
   signal flgStartAcquisition: STD_LOGIC;
   constant cstDivPresc: integer := 10000000;
   signal cntPresc: integer range 0 to cstDivPresc-1;

component audio_demo is
   port(
   clk_i       : in  std_logic;
   rst_i       : in  std_logic;
   
   pdm_clk_o   : out std_logic;
   pdm_lrsel_o : out std_logic;
   pdm_data_i  : in  std_logic;
   
   data_mic_valid : out std_logic;
   data_mic       : out std_logic_vector(15 downto 0);

   pdm_data_o  : out std_logic;
   pdm_en_o    : out std_logic
);
end component;

    component clk_wiz_0
    port
        (
        ck100MHz    : in    std_logic;
        ck4800kHz   : out   std_logic;
        ck25MHz     : out   std_logic;
        reset       : in    std_logic;
        locked      : out   std_logic
        );
    end component;

ATTRIBUTE SYN_BLACK_BOX OF clk_wiz_0 : COMPONENT IS TRUE;


ATTRIBUTE BLACK_BOX_PAD_PIN OF clk_wiz_0 : COMPONENT IS "ck100MHz,ck4800kHz,ck25MHz,reset,locked";

	COMPONENT VgaCtrl
	PORT(
		ckVideo : IN std_logic;          
		adrHor : OUT integer range 0 to cstHorSize - 1;
		adrVer : OUT integer range 0 to cstVerSize - 1;
		flgActiveVideo : OUT std_logic;
		HS : OUT std_logic;
		VS : OUT std_logic
		);
	END COMPONENT;

	COMPONENT ImgCtrl
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
	END COMPONENT;
	
	component LedStringCtrl 
    Port ( 
        ck100MHz: in std_logic;
        flgFreqSampleValid: in STD_LOGIC;
        addraFreq: in STD_LOGIC_VECTOR (9 downto 0);
        byteFreqSample: in STD_LOGIC_VECTOR (7 downto 0);
        bitDataNrz : out  STD_LOGIC;
        sw: in STD_LOGIC_VECTOR (15 downto 14)
        );
    end component;
	
	component FftBlock
    Port ( 
        flgStartAcquisition : in std_logic;
        sw: in std_logic_vector(2 downto 0);
        ckaTime : in STD_LOGIC;
        enaTime : out STD_LOGIC;
        weaTime : out STD_LOGIC;
        addraTime : out STD_LOGIC_VECTOR (9 downto 0);
        dinaTime : in STD_LOGIC_VECTOR (7 downto 0);
        ckFreq : in STD_LOGIC;
        flgFreqSampleValid : out STD_LOGIC;
        addrFreq : out STD_LOGIC_VECTOR (9 downto 0);
        byteFreqSample : out STD_LOGIC_VECTOR (7 downto 0)
        );   
   end component;

begin

   prescaller: process(ck100MHz)
   begin
      if rising_edge(ck100MHz) then
         if cntPresc = cstDivPresc - 1 then
            cntPresc <= 0;
            flgStartAcquisition <= '1';
         else
            cntPresc <= cntPresc +1;
            flgStartAcquisition <= '0';
         end if;
      end if;
   end process;         

clkGenInst: clk_wiz_0
      port map ( 
   
      ck100MHz => ck100MHz,
      ck4800kHz => open,
      ck25MHz => ck25MHz,               
      reset => '0',
      locked => open            
    );

Audio_demo_inst: audio_demo
      port map ( 
         clk_i         => ck100MHz,
         rst_i         => '0',
         pdm_clk_o     => micClk,        
         pdm_data_i    => micData,                
         pdm_lrsel_o   => micLRSel,
         data_mic_valid => flgTimeSampleValid,
         data_mic      => wordTimeSample,
         pdm_data_o    => pdm_data_o,          
         pdm_en_o      => pdm_en_o
      );
   
Inst_fftBlock: FftBlock Port Map(
      flgStartAcquisition => flgStartAcquisition,
      sw => sw(2 downto 0),
      ckaTime => ck100MHz,
      enaTime => flgTimeFrameActive,
      weaTime => flgTimeSampleValid,
      addraTime => addraTime,
      dinaTime => wordTimeSample(10 downto 3),
      ckFreq => ck25MHz,
      flgFreqSampleValid => flgFreqSampleValid,
      addrFreq => addraFreq,
      byteFreqSample => byteFreqSample
   );

Inst_VgaCtrl: VgaCtrl PORT MAP(
		ckVideo => ck25MHz,
		adrHor => adrHor,
		adrVer => adrVer,
		flgActiveVideo => flgActiveVideo,
		HS => Hsync,
		VS => Vsync
	);

Inst_ImgCtrl: ImgCtrl PORT MAP(
        ck100MHz => ck100MHz,      
        enaTime => flgTimeFrameActive,
        weaTime => flgTimeSampleValid,
        addraTime => addraTime,
        dinaTime => wordTimeSample(10 downto 3),
        weaFreq => flgFreqSampleValid,
        addraFreq => addraFreq,
        dinaFreq => byteFreqSample,
        ckVideo => ck25MHz,
        flgActiveVideo => flgActiveVideo,
        adrHor => adrHor,
        adrVer => adrVer,
        red => vgaRed,
        green => vgaGreen,
        blue => vgaBlue
	);

inst_LedStringCtrl: LedStringCtrl 
    Port map(
       ck100MHz => ck100MHz,
       flgFreqSampleValid => flgFreqSampleValid,
       addraFreq => addraFreq,
       byteFreqSample => byteFreqSample,
	   bitDataNrz => bitDataNrz,
       sw => sw(15 downto 14));

end Behavioral;
