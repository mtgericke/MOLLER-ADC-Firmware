## 1 Timing Assertions Section
# 1.1 Primary clocks
create_clock -period 20.000 -name UC_REB_IN [get_ports UC_REB_IN]
create_clock -period 20.000 -name UC_WEB_IN [get_ports UC_WEB_IN]
create_clock -period 52.083 -name CLKREF_TCXO [get_ports CLKREF_TCXO]
create_clock -period 6.400 -name MGTREFCLK [get_ports MGTREFCLK0N]
create_clock -period 6.400 -name CLK156g [get_pins xaui_wrapper_i/U0/xaui_wrapper_init_i/xaui_wrapper_i/gt0_xaui_wrapper_i/gtpe2_i/TXOUTCLK]
create_clock -period 100.000 -name CLKREF_EXT -waveform {0.000 50.000} [get_ports CLKREF_EXT]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks clkout0] -group [get_clocks -include_generated_clocks CLKREF_EXT]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLKREF_EXT_IBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLKREF_TCXO]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets UC_REB_IN]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets UC_WEB_IN]

# 1.2 generated clocks
#create_generated_clock -name DNA_ID_001/CLK_DIV2_reg_n_0 -source [get_pins xaui_wrapper_i/U0/common0_i/gtpe2_common_i/PLL0OUTCLK] -divide_by 2 [get_pins DNA_ID_001/CLK_DIV2_reg/Q]

# 1.3 Forwarded clocks

# 1.4 Input and output delay constraints

## 2 Timing Exceptions Section
# The following cross clock domain false path constraints can be uncommented in order to mimic ucf constraints behavior (see message at the beginning of this file)
set_false_path -from [get_clocks UC_REB_IN] -to [get_clocks {UC_WEB_IN CLK156g}]
set_false_path -from [get_clocks UC_WEB_IN] -to [get_clocks {UC_REB_IN CLK156g}]
set_false_path -from [get_clocks CLKREF_TCXO] -to [get_clocks UC_REB_IN]

## 3 Physical Constraints Section
# place FFs in IOBs for all key inputs/outputs

#----------------------------------------------------------------
# EXTERNAL 10G ETHERNET LAN
#----------------------------------------------------------------
# COM-5404 10G plug-in module through left connector
set_property PACKAGE_PIN F6 [get_ports MGTREFCLK0P]
set_property PACKAGE_PIN E6 [get_ports MGTREFCLK0N]
set_property PACKAGE_PIN A8 [get_ports XAUI_RX_L0_N]
set_property PACKAGE_PIN B8 [get_ports XAUI_RX_L0_P]
set_property PACKAGE_PIN A4 [get_ports XAUI_TX_L0_N]
set_property PACKAGE_PIN B4 [get_ports XAUI_TX_L0_P]
set_property PACKAGE_PIN C11 [get_ports XAUI_RX_L1_N]
set_property PACKAGE_PIN D11 [get_ports XAUI_RX_L1_P]
set_property PACKAGE_PIN C5 [get_ports XAUI_TX_L1_N]
set_property PACKAGE_PIN D5 [get_ports XAUI_TX_L1_P]
set_property PACKAGE_PIN A10 [get_ports XAUI_RX_L2_N]
set_property PACKAGE_PIN B10 [get_ports XAUI_RX_L2_P]
set_property PACKAGE_PIN A6 [get_ports XAUI_TX_L2_N]
set_property PACKAGE_PIN B6 [get_ports XAUI_TX_L2_P]
set_property PACKAGE_PIN C9 [get_ports XAUI_RX_L3_N]
set_property PACKAGE_PIN D9 [get_ports XAUI_RX_L3_P]
set_property PACKAGE_PIN C7 [get_ports XAUI_TX_L3_N]
set_property PACKAGE_PIN D7 [get_ports XAUI_TX_L3_P]

set_property PACKAGE_PIN AB1 [get_ports {LEFT_CONNECTOR_A[1]}]
set_property PACKAGE_PIN AA1 [get_ports {LEFT_CONNECTOR_A[2]}]
set_property PACKAGE_PIN AA3 [get_ports {LEFT_CONNECTOR_A[3]}]
set_property PACKAGE_PIN Y3 [get_ports {LEFT_CONNECTOR_A[4]}]
set_property PACKAGE_PIN AB5 [get_ports {LEFT_CONNECTOR_A[5]}]
set_property PACKAGE_PIN AA5 [get_ports {LEFT_CONNECTOR_A[6]}]
set_property PACKAGE_PIN AA6 [get_ports {LEFT_CONNECTOR_A[7]}]
set_property PACKAGE_PIN Y6 [get_ports {LEFT_CONNECTOR_A[8]}]
set_property PACKAGE_PIN AB8 [get_ports {LEFT_CONNECTOR_A[9]}]

set_property PULLDOWN true [get_ports {LEFT_CONNECTOR_A[3]}]
#10G PHY RESET#
set_property PULLUP true [get_ports {LEFT_CONNECTOR_A[8]}]
#10G PHY PGOODN1.2V
set_property PULLUP true [get_ports {LEFT_CONNECTOR_A[9]}]
#10G PHY PGOODN3.3V

set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEFT_CONNECTOR_A[9]}]

#----------------------------------------------------------------
# ARM MICRO
#----------------------------------------------------------------
set_property PACKAGE_PIN U15 [get_ports UC_ALE_IN]
set_property PACKAGE_PIN V15 [get_ports UC_REB_IN]
set_property PACKAGE_PIN T14 [get_ports UC_WEB_IN]
set_property PACKAGE_PIN T15 [get_ports UC_CSIB_IN]
set_property PACKAGE_PIN V10 [get_ports {UC_AD[0]}]
set_property PACKAGE_PIN W10 [get_ports {UC_AD[1]}]
set_property PACKAGE_PIN Y11 [get_ports {UC_AD[2]}]
set_property PACKAGE_PIN Y12 [get_ports {UC_AD[3]}]
set_property PACKAGE_PIN W11 [get_ports {UC_AD[4]}]
set_property PACKAGE_PIN W12 [get_ports {UC_AD[5]}]
set_property PACKAGE_PIN V13 [get_ports {UC_AD[6]}]
set_property PACKAGE_PIN V14 [get_ports {UC_AD[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports UC_ALE_IN]
set_property IOSTANDARD LVCMOS33 [get_ports UC_REB_IN]
set_property IOSTANDARD LVCMOS33 [get_ports UC_WEB_IN]
set_property IOSTANDARD LVCMOS33 [get_ports UC_CSIB_IN]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UC_AD[0]}]


# pins
set_property PACKAGE_PIN F15 [get_ports CLKREF_TCXO]
set_property IOSTANDARD LVCMOS15 [get_ports CLKREF_TCXO]
set_property PACKAGE_PIN F20 [get_ports CLKREF_EXT]
set_property IOSTANDARD LVCMOS15 [get_ports CLKREF_EXT]

set_property PACKAGE_PIN W1 [get_ports {RIGHT_CONNECTOR_A[2]}]
set_property PACKAGE_PIN Y1 [get_ports {RIGHT_CONNECTOR_A[1]}]
set_property PACKAGE_PIN W4 [get_ports {RIGHT_CONNECTOR_A[3]}]
set_property PACKAGE_PIN V4 [get_ports {RIGHT_CONNECTOR_A[4]}]
set_property PACKAGE_PIN V8 [get_ports {RIGHT_CONNECTOR_A[5]}]
set_property PACKAGE_PIN V9 [get_ports {RIGHT_CONNECTOR_A[6]}]
set_property PACKAGE_PIN V2 [get_ports {RIGHT_CONNECTOR_A[7]}]
set_property PACKAGE_PIN U2 [get_ports {RIGHT_CONNECTOR_A[8]}]
set_property PACKAGE_PIN T5 [get_ports {RIGHT_CONNECTOR_A[10]}]
set_property PACKAGE_PIN U5 [get_ports {RIGHT_CONNECTOR_A[9]}]
set_property PACKAGE_PIN U1 [get_ports {RIGHT_CONNECTOR_A[11]}]
set_property PACKAGE_PIN T1 [get_ports {RIGHT_CONNECTOR_A[12]}]
set_property PACKAGE_PIN T4 [get_ports {RIGHT_CONNECTOR_A[13]}]
set_property PACKAGE_PIN R4 [get_ports {RIGHT_CONNECTOR_A[14]}]
set_property PACKAGE_PIN P1 [get_ports {RIGHT_CONNECTOR_A[15]}]
set_property PACKAGE_PIN R1 [get_ports {RIGHT_CONNECTOR_A[16]}]
set_property PACKAGE_PIN P4 [get_ports {RIGHT_CONNECTOR_A[17]}]
set_property PACKAGE_PIN P5 [get_ports {RIGHT_CONNECTOR_A[18]}]
set_property PACKAGE_PIN N5 [get_ports {RIGHT_CONNECTOR_A[19]}]
set_property PACKAGE_PIN P6 [get_ports {RIGHT_CONNECTOR_A[20]}]
set_property PACKAGE_PIN M5 [get_ports {RIGHT_CONNECTOR_A[21]}]
set_property PACKAGE_PIN M6 [get_ports {RIGHT_CONNECTOR_A[22]}]
set_property PACKAGE_PIN K3 [get_ports {RIGHT_CONNECTOR_A[23]}]
set_property PACKAGE_PIN L3 [get_ports {RIGHT_CONNECTOR_A[24]}]
set_property PACKAGE_PIN J1 [get_ports {RIGHT_CONNECTOR_A[25]}]
set_property PACKAGE_PIN K1 [get_ports {RIGHT_CONNECTOR_A[26]}]
set_property PACKAGE_PIN J4 [get_ports {RIGHT_CONNECTOR_A[27]}]
set_property PACKAGE_PIN K4 [get_ports {RIGHT_CONNECTOR_A[28]}]
set_property PACKAGE_PIN H5 [get_ports {RIGHT_CONNECTOR_A[29]}]
set_property PACKAGE_PIN J5 [get_ports {RIGHT_CONNECTOR_A[30]}]
set_property PACKAGE_PIN G3 [get_ports {RIGHT_CONNECTOR_A[31]}]
set_property PACKAGE_PIN H3 [get_ports {RIGHT_CONNECTOR_A[32]}]
set_property PACKAGE_PIN E3 [get_ports {RIGHT_CONNECTOR_A[33]}]
set_property PACKAGE_PIN F3 [get_ports {RIGHT_CONNECTOR_A[34]}]
set_property PACKAGE_PIN D2 [get_ports {RIGHT_CONNECTOR_A[35]}]
set_property PACKAGE_PIN E2 [get_ports {RIGHT_CONNECTOR_A[36]}]
set_property PACKAGE_PIN B2 [get_ports {RIGHT_CONNECTOR_A[37]}]
set_property PACKAGE_PIN C2 [get_ports {RIGHT_CONNECTOR_A[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[37]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[36]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[35]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[34]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[33]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_A[1]}]

set_property PACKAGE_PIN Y2 [get_ports {RIGHT_CONNECTOR_B1[1]}]
set_property PACKAGE_PIN W2 [get_ports {RIGHT_CONNECTOR_B1[2]}]
set_property PACKAGE_PIN W7 [get_ports {RIGHT_CONNECTOR_B1[3]}]
set_property PACKAGE_PIN V7 [get_ports {RIGHT_CONNECTOR_B1[4]}]
set_property PACKAGE_PIN V5 [get_ports {RIGHT_CONNECTOR_B2[6]}]
set_property PACKAGE_PIN U6 [get_ports {RIGHT_CONNECTOR_B2[7]}]
set_property PACKAGE_PIN V3 [get_ports {RIGHT_CONNECTOR_B2[8]}]
set_property PACKAGE_PIN U3 [get_ports {RIGHT_CONNECTOR_B2[9]}]
set_property PACKAGE_PIN R2 [get_ports {RIGHT_CONNECTOR_B2[10]}]
set_property PACKAGE_PIN R3 [get_ports {RIGHT_CONNECTOR_B2[11]}]
set_property PACKAGE_PIN T6 [get_ports {RIGHT_CONNECTOR_B2[12]}]
set_property PACKAGE_PIN R6 [get_ports {RIGHT_CONNECTOR_B2[13]}]
set_property PACKAGE_PIN N2 [get_ports {RIGHT_CONNECTOR_B2[14]}]
set_property PACKAGE_PIN P2 [get_ports {RIGHT_CONNECTOR_B2[15]}]
set_property PACKAGE_PIN N3 [get_ports {RIGHT_CONNECTOR_B2[16]}]
set_property PACKAGE_PIN N4 [get_ports {RIGHT_CONNECTOR_B2[17]}]

set_property PACKAGE_PIN M2 [get_ports {RIGHT_CONNECTOR_B2[18]}]
set_property PACKAGE_PIN M3 [get_ports {RIGHT_CONNECTOR_B2[19]}]
set_property PACKAGE_PIN L1 [get_ports {RIGHT_CONNECTOR_B3[21]}]
set_property PACKAGE_PIN M1 [get_ports {RIGHT_CONNECTOR_B3[22]}]
set_property PACKAGE_PIN L4 [get_ports {RIGHT_CONNECTOR_B3[23]}]
set_property PACKAGE_PIN L5 [get_ports {RIGHT_CONNECTOR_B3[24]}]
set_property PACKAGE_PIN J2 [get_ports {RIGHT_CONNECTOR_B3[25]}]
set_property PACKAGE_PIN K2 [get_ports {RIGHT_CONNECTOR_B3[26]}]
set_property PACKAGE_PIN J6 [get_ports {RIGHT_CONNECTOR_B3[27]}]
set_property PACKAGE_PIN K6 [get_ports {RIGHT_CONNECTOR_B3[28]}]
set_property PACKAGE_PIN G2 [get_ports {RIGHT_CONNECTOR_B3[29]}]
set_property PACKAGE_PIN H2 [get_ports {RIGHT_CONNECTOR_B3[30]}]
set_property PACKAGE_PIN G4 [get_ports {RIGHT_CONNECTOR_B4[32]}]
set_property PACKAGE_PIN H4 [get_ports {RIGHT_CONNECTOR_B4[33]}]
set_property PACKAGE_PIN F1 [get_ports {RIGHT_CONNECTOR_B4[34]}]
set_property PACKAGE_PIN G1 [get_ports {RIGHT_CONNECTOR_B4[35]}]
set_property PACKAGE_PIN D1 [get_ports {RIGHT_CONNECTOR_B4[36]}]
set_property PACKAGE_PIN E1 [get_ports {RIGHT_CONNECTOR_B4[37]}]
set_property PACKAGE_PIN A1 [get_ports {RIGHT_CONNECTOR_B4[38]}]
set_property PACKAGE_PIN B1 [get_ports {RIGHT_CONNECTOR_B4[39]}]


set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B2[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B3[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[32]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[33]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[34]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[35]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[36]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[37]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[38]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RIGHT_CONNECTOR_B4[39]}]




