-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
-- Date        : Thu Sep  7 03:08:23 2023
-- Host        : home running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub /home/xil/hdl/src/mmcm_adc/mmcm_adc_stub.vhdl
-- Design      : mmcm_adc
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu6cg-ffvc900-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mmcm_adc is
  Port ( 
    clk_adc_cnv : out STD_LOGIC;
    clk_adc : out STD_LOGIC;
    clk_625 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end mmcm_adc;

architecture stub of mmcm_adc is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_adc_cnv,clk_adc,clk_625,reset,locked,clk_in1";
begin
end;
