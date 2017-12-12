################################################################################
# Author : Wesley
# Hardware : Arty-A7
# Description : Hardware configuration for ARTY-A7 board and corresponding top
################################################################################



set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports CLK_100M]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK_100M]

set_property -dict { PACKAGE_PIN C2 IOSTANDARD LVCMOS33 }  [get_ports RESET_n]
set_property -dict { PACKAGE_PIN A9 IOSTANDARD LVCMOS33 }  [get_ports UART_rxd]
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports UART_txd]

set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports {BTN[3]}]
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports {BTN[2]}]
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports {BTN[1]}]
set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports {BTN[0]}]

set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports {SWT[3]}]
set_property -dict { PACKAGE_PIN C10 IOSTANDARD LVCMOS33 } [get_ports {SWT[2]}]
set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33 } [get_ports {SWT[1]}]
set_property -dict { PACKAGE_PIN A8  IOSTANDARD LVCMOS33 } [get_ports {SWT[0]}]

set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports {LED[3]}]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports {LED[2]}]
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports {LED[1]}]
set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports {LED[0]}]

set_property -dict { PACKAGE_PIN K2 IOSTANDARD LVCMOS33 } [get_ports {LED_B[3]}]
set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports {LED_B[2]}]
set_property -dict { PACKAGE_PIN G4 IOSTANDARD LVCMOS33 } [get_ports {LED_B[1]}]
set_property -dict { PACKAGE_PIN E1 IOSTANDARD LVCMOS33 } [get_ports {LED_B[0]}]
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports {LED_R[3]}]
set_property -dict { PACKAGE_PIN J3 IOSTANDARD LVCMOS33 } [get_ports {LED_R[2]}]
set_property -dict { PACKAGE_PIN G3 IOSTANDARD LVCMOS33 } [get_ports {LED_R[1]}]
set_property -dict { PACKAGE_PIN G6 IOSTANDARD LVCMOS33 } [get_ports {LED_R[0]}]
set_property -dict { PACKAGE_PIN H6 IOSTANDARD LVCMOS33 } [get_ports {LED_G[3]}]
set_property -dict { PACKAGE_PIN J2 IOSTANDARD LVCMOS33 } [get_ports {LED_G[2]}]
set_property -dict { PACKAGE_PIN J4 IOSTANDARD LVCMOS33 } [get_ports {LED_G[1]}]
set_property -dict { PACKAGE_PIN F6 IOSTANDARD LVCMOS33 } [get_ports {LED_G[0]}]

#connect to PMOD JB
set_property -dict { PACKAGE_PIN E15 IOSTANDARD LVCMOS33 } [get_ports {SD_DATA[3]}]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports {SD_DATA[2]}]
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports {SD_DATA[1]}]
set_property -dict { PACKAGE_PIN D15 IOSTANDARD LVCMOS33 } [get_ports {SD_DATA[0]}]
set_property -dict { PACKAGE_PIN E16 IOSTANDARD LVCMOS33 } [get_ports SD_CMD]
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33 } [get_ports SD_SCLK]
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports SD_CD]
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports SD_WP]

