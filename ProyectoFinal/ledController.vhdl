library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led_controller is
	 generic (N: integer; 
	          cstCkFrequency: real);
        Port (ckSys : in  STD_LOGIC;
			  addr: integer range 0 to  N - 1;
			  red: in std_logic_vector(7 downto 0);
			  green: in std_logic_vector(7 downto 0);
			  blue: in std_logic_vector(7 downto 0);
			  write_en: in std_logic;
              cmd : out	STD_LOGIC);
end led_controller;

architecture Behavioral of led_controller is

	type mem is array (0 to N-1) of std_logic_vector(23 downto 0);
	signal myRam: mem := (others => X"000000");
	
	constant cstReset: integer := integer((1220.0e-9)*cstCkFrequency); 
	signal cntReset: integer range 0 to cstReset - 1 := 0;

	constant cst420ns: integer := integer((420.0e-9)*cstCkFrequency);
	signal cnt420ns: integer range 0 to cst420ns - 1 := 0;
	signal delay_420ns: std_logic := '0';

	signal cntBitIndex: integer range 0 to 23;
	
	type state_machine is (st_reset, st_send_bit1, st_send_bit2, st_send_bit3);
	signal state: state_machine := st_reset;
	
	signal ram_data: std_logic_vector(23 downto 0) := (others => '0');
	signal cntLedIndex: integer range 0 to N - 1 := 0;
	signal led_TX: std_logic := '0';
	
begin
	
	cmd <= led_TX;
	
	process(ckSys)
	begin
		if(ckSys'event and ckSys = '1')then
			if(write_en = '1') then
				myRam(addr) <= green & red & blue;
			end if;
		end if;
	end process;
	
	process(ckSys)
	begin
		if(ckSys'event and ckSys = '1')then
			if(cnt420ns = cst420ns - 1) then
				cnt420ns <= 0;
				delay_420ns <= '1';
			else
				cnt420ns <= cnt420ns + 1;
				delay_420ns <= '0';
			end if; 
		end if;
	end process;
	
	state_ctrl: process(ckSys)
	begin
		if(ckSys'event and ckSys = '1' ) then
			if(delay_420ns = '1') then
				if(state = st_reset)then
					led_TX <= '0';
					if(cntReset < cstReset - 1) then
						cntReset <= cntReset + 1;
					else
						cntReset <= 0;
						cntBitIndex <= 23;
						state <= st_send_bit1;
						cntLedIndex <= 0;
					end if;
				elsif(state = st_send_bit1)then
					led_TX <= '1';
					state <= st_send_bit2;
					ram_data <= myRam(cntLedIndex);
				elsif(state = st_send_bit2)then
					led_TX <= ram_data(cntBitIndex);
					state <= st_send_bit3;
				elsif(state = st_send_bit3)then
					led_TX <= '0';
					
					if(cntBitIndex = 0 and cntLedIndex = N-1) then
						state <= st_reset;
						cntBitIndex <= 23;
						cntLedIndex <= 0;
					elsif(cntBitIndex = 0 and cntLedIndex < N-1) then
						cntLedIndex <= cntLedIndex + 1;
						cntBitIndex <= 23;
						state <= st_send_bit1;
					else
						cntBitIndex <= cntBitIndex - 1;
						state <= st_send_bit1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;
