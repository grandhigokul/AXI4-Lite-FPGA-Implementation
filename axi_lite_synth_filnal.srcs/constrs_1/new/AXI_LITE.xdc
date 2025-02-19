# Assign FPGA Pins for Inputs
set_property PACKAGE_PIN Y9 [get_ports ACLK]
set_property PACKAGE_PIN F22 [get_ports ARESETN]
set_property PACKAGE_PIN G22 [get_ports START_READ]
set_property PACKAGE_PIN H22 [get_ports START_WRITE]

# Set I/O Standard for Inputs
set_property IOSTANDARD LVCMOS33 [get_ports ACLK]
set_property IOSTANDARD LVCMOS33 [get_ports ARESETN]
set_property IOSTANDARD LVCMOS33 [get_ports START_READ]
set_property IOSTANDARD LVCMOS33 [get_ports START_WRITE]

# Debug Hub Configuration (Directly Use ACLK)

# Connect Debug Hub Directly to ACLK Instead of clk_gen

# Define Primary Input Clock (ACLK) - Board's Clock Source (100 MHz)
create_clock -period 10.000 [get_ports ACLK]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list ACLK_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {S_RDATA[0]} {S_RDATA[1]} {S_RDATA[2]} {S_RDATA[3]} {S_RDATA[4]} {S_RDATA[5]} {S_RDATA[6]} {S_RDATA[7]} {S_RDATA[8]} {S_RDATA[9]} {S_RDATA[10]} {S_RDATA[11]} {S_RDATA[12]} {S_RDATA[13]} {S_RDATA[14]} {S_RDATA[15]} {S_RDATA[16]} {S_RDATA[17]} {S_RDATA[18]} {S_RDATA[19]} {S_RDATA[20]} {S_RDATA[21]} {S_RDATA[22]} {S_RDATA[23]} {S_RDATA[24]} {S_RDATA[25]} {S_RDATA[26]} {S_RDATA[27]} {S_RDATA[28]} {S_RDATA[29]} {S_RDATA[30]} {S_RDATA[31]}]]
set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets ACLK_IBUF_BUFG]
