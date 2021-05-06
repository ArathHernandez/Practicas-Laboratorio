LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lcd_example IS
  PORT(
      clk       : IN  STD_LOGIC;  --system clock
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
END lcd_example;

ARCHITECTURE behavior OF lcd_example IS
  SIGNAL   lcd_enable : STD_LOGIC;
  SIGNAL   lcd_bus    : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL   lcd_busy   : STD_LOGIC;
  COMPONENT lcd_controller IS
    PORT(
       clk        : IN  STD_LOGIC; --system clock
       reset_n    : IN  STD_LOGIC; --active low reinitializes lcd
       lcd_enable : IN  STD_LOGIC; --latches data into lcd controller
       lcd_bus    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); --data and control signals
       busy       : OUT STD_LOGIC; --lcd controller busy/idle feedback
       rw, rs, e  : OUT STD_LOGIC; --read/write, setup/data, and enable for lcd
       lcd_data   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
  END COMPONENT;
BEGIN

  --
--instantiate the lcd controller
  dut: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
             busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  
  PROCESS(clk)
    VARIABLE char  :  INTEGER RANGE 0 TO 14 := 0;
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      IF(lcd_busy = '0' AND lcd_enable = '0') THEN
        lcd_enable <= '1';
        IF(char < 14) THEN
          char := char + 1;
        END IF;
        CASE char IS
        -- 01010011 01100101 01110010 01110010 01100001 01110100 01101111 Serrato
        -- 01000101 01110010 01100010 01100101 01111001  Erbey
        -- 00100000 Espacio
          WHEN 1 => lcd_bus <= "1001010011";--S
          WHEN 2 => lcd_bus <= "1001100101";--e
          WHEN 3 => lcd_bus <= "1001110010";--r
          WHEN 4 => lcd_bus <= "1001110010";--r
          WHEN 5 => lcd_bus <= "1001100001";--a
          WHEN 6 => lcd_bus <= "1001110100";--t
          WHEN 7 => lcd_bus <= "1001101111";--o
WHEN 8 => lcd_bus <= "0011000000";--Direccion 64
          WHEN 9 => lcd_bus <= "1001000101";--E
          WHEN 10 => lcd_bus <= "1001110010";--b
          WHEN 11 => lcd_bus <= "1001100010";--r
          WHEN 12 => lcd_bus <= "1001100101";--e
          WHEN 13 => lcd_bus <= "1001111001";--y
          WHEN OTHERS => lcd_enable <= '0';
        END CASE;
      ELSE
        lcd_enable <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END behavior;
