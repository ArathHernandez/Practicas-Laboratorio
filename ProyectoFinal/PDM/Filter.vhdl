library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity pdm_filter is
   port(
      -- global signals
      clk_i             : in  std_logic; -- 100 MHz system clock
      rst_i             : in  std_logic; -- active-high system reset
      
      -- PDM interface to microphone
      pdm_clk_o         : out std_logic;
      pdm_lrsel_o       : out std_logic;
      pdm_data_i        : in  std_logic;
      
      -- output data
      fs_o              : out std_logic;
      data_o            : out std_logic_vector(15 downto 0)
   );
end pdm_filter;

architecture Behavioral of pdm_filter is
component clk_gen
   port(
      clk_100MHz_i         : in  std_logic;
      clk_6_144MHz_o       : out std_logic;
      rst_i                : in  std_logic;
      locked_o             : out std_logic);
end component;
component cic
   port(
      aclk                 : in  std_logic;
      s_axis_data_tdata    : in  std_logic_vector(7 downto 0);
      s_axis_data_tvalid   : in  std_logic;
      s_axis_data_tready   : out std_logic;
      m_axis_data_tdata    : out std_logic_vector(23 downto 0);
      m_axis_data_tvalid   : out std_logic);
end component;
   
component hb_fir
   port(
      aclk                 : in  std_logic;
      s_axis_data_tvalid   : in  std_logic;
      s_axis_data_tready   : out std_logic;
      s_axis_data_tdata    : in  std_logic_vector(23 downto 0);
      m_axis_data_tvalid   : out std_logic;
      m_axis_data_tready   : in  std_logic;
      m_axis_data_tdata    : out std_logic_vector(23 downto 0));
end component;

component lp_fir
   port(
      aclk                 : in  std_logic;
      s_axis_data_tvalid   : in  std_logic;
      s_axis_data_tready   : out std_logic;
      s_axis_data_tdata    : in  std_logic_vector(23 downto 0);
      m_axis_data_tvalid   : out std_logic;
      m_axis_data_tdata    : out std_logic_vector(23 downto 0));
end component;

component hp_rc
   port(
      clk_i                : in  std_logic;
      rst_i                : in  std_logic;
      en_i                 : in  std_logic;
      data_i               : in  std_logic_vector(15 downto 0);
      data_o               : out std_logic_vector(15 downto 0));
end component;
signal clk_3_072MHz     : std_logic;
signal clk_3_072MHz_int : std_logic;
signal clk_6_144MHz_int : std_logic;
signal clk_6_144MHz_div : std_logic;
signal clk_locked       : std_logic;

-- CIC signals
signal s_cic_tdata      : std_logic_vector(7 downto 0);
signal m_cic_tdata      : std_logic_vector(23 downto 0);
signal m_cic_tvalid     : std_logic;

-- HB signals
signal m_hb_tvalid      : std_logic;
signal m_hb_tready      : std_logic;
signal m_hb_tdata       : std_logic_vector(23 downto 0);

-- LP signals
signal m_lp_tvalid      : std_logic;
signal m_lp_tready      : std_logic;
signal m_lp_tdata       : std_logic_vector(23 downto 0);

begin

   ClkGen: clk_gen
   port map(
      clk_100MHz_i         => clk_i,
      clk_6_144MHz_o       => clk_6_144MHz_int,
      rst_i                => rst_i,
      locked_o             => clk_locked);
   ClkDiv2: BUFR
   generic map (
      BUFR_DIVIDE          => "2",
      SIM_DEVICE           => "7SERIES")
   port map(
      O                    => clk_6_144MHz_div,
      CE                   => '1',
      CLR                  => '0',
      I                    => clk_6_144MHz_int);
   
   ClkDivBuf: BUFG
   port map(
      O                    => clk_3_072MHz_int,
      I                    => clk_6_144MHz_div);
   
   clk_3_072MHz <= clk_3_072MHz_int when clk_locked = '1' else '1';
   pdm_clk_o <= clk_3_072MHz;
   
   pdm_lrsel_o <= '0';
   s_cic_tdata(7 downto 1) <= (others => (not pdm_data_i));
   s_cic_tdata(0) <= '1';
   CICd: cic
   port map(
      aclk                 => clk_3_072MHz,
      s_axis_data_tdata    => s_cic_tdata,
      s_axis_data_tvalid   => '1',
      s_axis_data_tready   => open,
      m_axis_data_tdata    => m_cic_tdata,
      m_axis_data_tvalid   => m_cic_tvalid);
   HB: hb_fir
   port map(
      aclk                 => clk_3_072MHz,
      s_axis_data_tvalid   => m_cic_tvalid,
      s_axis_data_tready   => open,
      s_axis_data_tdata    => m_cic_tdata,
      m_axis_data_tvalid   => m_hb_tvalid,
      m_axis_data_tready   => m_hb_tready,
      m_axis_data_tdata    => m_hb_tdata);
   LP: lp_fir
   port map(
      aclk                 => clk_3_072MHz,
      s_axis_data_tvalid   => m_hb_tvalid,
      s_axis_data_tready   => m_hb_tready,
      s_axis_data_tdata    => m_hb_tdata,
      m_axis_data_tvalid   => m_lp_tvalid,
      m_axis_data_tdata    => m_lp_tdata);

   HP: hp_rc
   port map(
      clk_i                => clk_3_072MHz,
      rst_i                => rst_i,
      en_i                 => m_lp_tvalid,
      data_i               => m_lp_tdata(16 downto 1),
      data_o               => data_o);
   
   fs_o <= m_lp_tvalid;
   
end Behavioral;
