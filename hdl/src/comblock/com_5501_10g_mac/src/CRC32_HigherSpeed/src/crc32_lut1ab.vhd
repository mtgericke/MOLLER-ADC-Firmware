-------------------------------------------------------------
-- Filename:  CRC32_LUT1ab.VHD
-- Authors: 
-- 	from http://www.xilinx.com/support/documentation/sw_manuals/xilinx14_4/xst_v6s6.pdf  p262
--		Alain Zarembowitch / MSS
-- Version: Rev 0
-- Last modified: 12/13/17
-- Inheritance: 	ROM1.vhd 8/24/16
--
-- description:  synthesizable generic dual port ROM containing two tables of 256 CRC32s values each
-- (called LUT1a and LUT1b)
-- The tables are generated by the Java application crc32tables in the /java folder
-- LUT1a computes the CRC32s for inputs in the form 00 00 00 x, where x is the LSB (last received byte)
-- LUT1b computes the CRC32s for inputs in the form 00 00 x 00
-- Data bit order: MSb of MSB is first sent/received
-- Note: the returned crc values are NOT inverted and NOT reflected left-right. They are as they would appear
-- when generated by a standard LFSR
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity CRC32_LUT1ab is
	 Generic (
		DATA_WIDTH: integer := 32;	
		ADDR_WIDTH: integer := 9
	);
    Port ( 
	    -- Port A
		ADDRA  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
			-- LUT1a at addresses 0 - 255
			-- LUT1b at addresses 256 - 511
		DOA  : out std_logic_vector(DATA_WIDTH-1 downto 0);

		-- Port B
		ADDRB  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
			-- LUT1a at addresses 0 - 255
			-- LUT1b at addresses 256 - 511
		DOB  : out std_logic_vector(DATA_WIDTH-1 downto 0)
		);
end entity;

architecture Behavioral of CRC32_LUT1ab is
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
-- inferred rom
signal DOA_local: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal DOB_local: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
type ROM_TYPE is array ( (2**ADDR_WIDTH)-1 downto 0 ) of std_logic_vector(DATA_WIDTH-1 downto 0);
-- IMPORTANT ORDER INFORMATION: the table below is read from bottom to top and right to left. Thus
-- to restore a common-sense order, address bits are inverted.
constant ROM : ROM_TYPE := (
-- LUT1a
x"00000000", x"04C11DB7", x"09823B6E", x"0D4326D9", x"130476DC", x"17C56B6B", x"1A864DB2", x"1E475005", 
x"2608EDB8", x"22C9F00F", x"2F8AD6D6", x"2B4BCB61", x"350C9B64", x"31CD86D3", x"3C8EA00A", x"384FBDBD", 
x"4C11DB70", x"48D0C6C7", x"4593E01E", x"4152FDA9", x"5F15ADAC", x"5BD4B01B", x"569796C2", x"52568B75", 
x"6A1936C8", x"6ED82B7F", x"639B0DA6", x"675A1011", x"791D4014", x"7DDC5DA3", x"709F7B7A", x"745E66CD", 
x"9823B6E0", x"9CE2AB57", x"91A18D8E", x"95609039", x"8B27C03C", x"8FE6DD8B", x"82A5FB52", x"8664E6E5", 
x"BE2B5B58", x"BAEA46EF", x"B7A96036", x"B3687D81", x"AD2F2D84", x"A9EE3033", x"A4AD16EA", x"A06C0B5D", 
x"D4326D90", x"D0F37027", x"DDB056FE", x"D9714B49", x"C7361B4C", x"C3F706FB", x"CEB42022", x"CA753D95", 
x"F23A8028", x"F6FB9D9F", x"FBB8BB46", x"FF79A6F1", x"E13EF6F4", x"E5FFEB43", x"E8BCCD9A", x"EC7DD02D", 
x"34867077", x"30476DC0", x"3D044B19", x"39C556AE", x"278206AB", x"23431B1C", x"2E003DC5", x"2AC12072", 
x"128E9DCF", x"164F8078", x"1B0CA6A1", x"1FCDBB16", x"018AEB13", x"054BF6A4", x"0808D07D", x"0CC9CDCA", 
x"7897AB07", x"7C56B6B0", x"71159069", x"75D48DDE", x"6B93DDDB", x"6F52C06C", x"6211E6B5", x"66D0FB02", 
x"5E9F46BF", x"5A5E5B08", x"571D7DD1", x"53DC6066", x"4D9B3063", x"495A2DD4", x"44190B0D", x"40D816BA", 
x"ACA5C697", x"A864DB20", x"A527FDF9", x"A1E6E04E", x"BFA1B04B", x"BB60ADFC", x"B6238B25", x"B2E29692", 
x"8AAD2B2F", x"8E6C3698", x"832F1041", x"87EE0DF6", x"99A95DF3", x"9D684044", x"902B669D", x"94EA7B2A", 
x"E0B41DE7", x"E4750050", x"E9362689", x"EDF73B3E", x"F3B06B3B", x"F771768C", x"FA325055", x"FEF34DE2", 
x"C6BCF05F", x"C27DEDE8", x"CF3ECB31", x"CBFFD686", x"D5B88683", x"D1799B34", x"DC3ABDED", x"D8FBA05A", 
x"690CE0EE", x"6DCDFD59", x"608EDB80", x"644FC637", x"7A089632", x"7EC98B85", x"738AAD5C", x"774BB0EB", 
x"4F040D56", x"4BC510E1", x"46863638", x"42472B8F", x"5C007B8A", x"58C1663D", x"558240E4", x"51435D53", 
x"251D3B9E", x"21DC2629", x"2C9F00F0", x"285E1D47", x"36194D42", x"32D850F5", x"3F9B762C", x"3B5A6B9B", 
x"0315D626", x"07D4CB91", x"0A97ED48", x"0E56F0FF", x"1011A0FA", x"14D0BD4D", x"19939B94", x"1D528623", 
x"F12F560E", x"F5EE4BB9", x"F8AD6D60", x"FC6C70D7", x"E22B20D2", x"E6EA3D65", x"EBA91BBC", x"EF68060B", 
x"D727BBB6", x"D3E6A601", x"DEA580D8", x"DA649D6F", x"C423CD6A", x"C0E2D0DD", x"CDA1F604", x"C960EBB3", 
x"BD3E8D7E", x"B9FF90C9", x"B4BCB610", x"B07DABA7", x"AE3AFBA2", x"AAFBE615", x"A7B8C0CC", x"A379DD7B", 
x"9B3660C6", x"9FF77D71", x"92B45BA8", x"9675461F", x"8832161A", x"8CF30BAD", x"81B02D74", x"857130C3", 
x"5D8A9099", x"594B8D2E", x"5408ABF7", x"50C9B640", x"4E8EE645", x"4A4FFBF2", x"470CDD2B", x"43CDC09C", 
x"7B827D21", x"7F436096", x"7200464F", x"76C15BF8", x"68860BFD", x"6C47164A", x"61043093", x"65C52D24", 
x"119B4BE9", x"155A565E", x"18197087", x"1CD86D30", x"029F3D35", x"065E2082", x"0B1D065B", x"0FDC1BEC", 
x"3793A651", x"3352BBE6", x"3E119D3F", x"3AD08088", x"2497D08D", x"2056CD3A", x"2D15EBE3", x"29D4F654", 
x"C5A92679", x"C1683BCE", x"CC2B1D17", x"C8EA00A0", x"D6AD50A5", x"D26C4D12", x"DF2F6BCB", x"DBEE767C", 
x"E3A1CBC1", x"E760D676", x"EA23F0AF", x"EEE2ED18", x"F0A5BD1D", x"F464A0AA", x"F9278673", x"FDE69BC4", 
x"89B8FD09", x"8D79E0BE", x"803AC667", x"84FBDBD0", x"9ABC8BD5", x"9E7D9662", x"933EB0BB", x"97FFAD0C", 
x"AFB010B1", x"AB710D06", x"A6322BDF", x"A2F33668", x"BCB4666D", x"B8757BDA", x"B5365D03", x"B1F740B4",
-- LUT1b
x"00000000", x"D219C1DC", x"A0F29E0F", x"72EB5FD3", x"452421A9", x"973DE075", x"E5D6BFA6", x"37CF7E7A", 
x"8A484352", x"5851828E", x"2ABADD5D", x"F8A31C81", x"CF6C62FB", x"1D75A327", x"6F9EFCF4", x"BD873D28", 
x"10519B13", x"C2485ACF", x"B0A3051C", x"62BAC4C0", x"5575BABA", x"876C7B66", x"F58724B5", x"279EE569", 
x"9A19D841", x"4800199D", x"3AEB464E", x"E8F28792", x"DF3DF9E8", x"0D243834", x"7FCF67E7", x"ADD6A63B", 
x"20A33626", x"F2BAF7FA", x"8051A829", x"524869F5", x"6587178F", x"B79ED653", x"C5758980", x"176C485C", 
x"AAEB7574", x"78F2B4A8", x"0A19EB7B", x"D8002AA7", x"EFCF54DD", x"3DD69501", x"4F3DCAD2", x"9D240B0E", 
x"30F2AD35", x"E2EB6CE9", x"9000333A", x"4219F2E6", x"75D68C9C", x"A7CF4D40", x"D5241293", x"073DD34F", 
x"BABAEE67", x"68A32FBB", x"1A487068", x"C851B1B4", x"FF9ECFCE", x"2D870E12", x"5F6C51C1", x"8D75901D", 
x"41466C4C", x"935FAD90", x"E1B4F243", x"33AD339F", x"04624DE5", x"D67B8C39", x"A490D3EA", x"76891236", 
x"CB0E2F1E", x"1917EEC2", x"6BFCB111", x"B9E570CD", x"8E2A0EB7", x"5C33CF6B", x"2ED890B8", x"FCC15164", 
x"5117F75F", x"830E3683", x"F1E56950", x"23FCA88C", x"1433D6F6", x"C62A172A", x"B4C148F9", x"66D88925", 
x"DB5FB40D", x"094675D1", x"7BAD2A02", x"A9B4EBDE", x"9E7B95A4", x"4C625478", x"3E890BAB", x"EC90CA77", 
x"61E55A6A", x"B3FC9BB6", x"C117C465", x"130E05B9", x"24C17BC3", x"F6D8BA1F", x"8433E5CC", x"562A2410", 
x"EBAD1938", x"39B4D8E4", x"4B5F8737", x"994646EB", x"AE893891", x"7C90F94D", x"0E7BA69E", x"DC626742", 
x"71B4C179", x"A3AD00A5", x"D1465F76", x"035F9EAA", x"3490E0D0", x"E689210C", x"94627EDF", x"467BBF03", 
x"FBFC822B", x"29E543F7", x"5B0E1C24", x"8917DDF8", x"BED8A382", x"6CC1625E", x"1E2A3D8D", x"CC33FC51", 
x"828CD898", x"50951944", x"227E4697", x"F067874B", x"C7A8F931", x"15B138ED", x"675A673E", x"B543A6E2", 
x"08C49BCA", x"DADD5A16", x"A83605C5", x"7A2FC419", x"4DE0BA63", x"9FF97BBF", x"ED12246C", x"3F0BE5B0", 
x"92DD438B", x"40C48257", x"322FDD84", x"E0361C58", x"D7F96222", x"05E0A3FE", x"770BFC2D", x"A5123DF1", 
x"189500D9", x"CA8CC105", x"B8679ED6", x"6A7E5F0A", x"5DB12170", x"8FA8E0AC", x"FD43BF7F", x"2F5A7EA3", 
x"A22FEEBE", x"70362F62", x"02DD70B1", x"D0C4B16D", x"E70BCF17", x"35120ECB", x"47F95118", x"95E090C4", 
x"2867ADEC", x"FA7E6C30", x"889533E3", x"5A8CF23F", x"6D438C45", x"BF5A4D99", x"CDB1124A", x"1FA8D396", 
x"B27E75AD", x"6067B471", x"128CEBA2", x"C0952A7E", x"F75A5404", x"254395D8", x"57A8CA0B", x"85B10BD7", 
x"383636FF", x"EA2FF723", x"98C4A8F0", x"4ADD692C", x"7D121756", x"AF0BD68A", x"DDE08959", x"0FF94885", 
x"C3CAB4D4", x"11D37508", x"63382ADB", x"B121EB07", x"86EE957D", x"54F754A1", x"261C0B72", x"F405CAAE", 
x"4982F786", x"9B9B365A", x"E9706989", x"3B69A855", x"0CA6D62F", x"DEBF17F3", x"AC544820", x"7E4D89FC", 
x"D39B2FC7", x"0182EE1B", x"7369B1C8", x"A1707014", x"96BF0E6E", x"44A6CFB2", x"364D9061", x"E45451BD", 
x"59D36C95", x"8BCAAD49", x"F921F29A", x"2B383346", x"1CF74D3C", x"CEEE8CE0", x"BC05D333", x"6E1C12EF", 
x"E36982F2", x"3170432E", x"439B1CFD", x"9182DD21", x"A64DA35B", x"74546287", x"06BF3D54", x"D4A6FC88", 
x"6921C1A0", x"BB38007C", x"C9D35FAF", x"1BCA9E73", x"2C05E009", x"FE1C21D5", x"8CF77E06", x"5EEEBFDA", 
x"F33819E1", x"2121D83D", x"53CA87EE", x"81D34632", x"B61C3848", x"6405F994", x"16EEA647", x"C4F7679B", 
x"79705AB3", x"AB699B6F", x"D982C4BC", x"0B9B0560", x"3C547B1A", x"EE4DBAC6", x"9CA6E515", x"4EBF24C9"
   	);

--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin

-- Port A read
DOA <= ROM(to_integer(unsigned(not ADDRA)));	-- see IMPORTANT ORDER INFORMATION above
 

-- Port B read
DOB <= ROM(to_integer(unsigned(not ADDRB)));	-- see IMPORTANT ORDER INFORMATION above

end Behavioral;