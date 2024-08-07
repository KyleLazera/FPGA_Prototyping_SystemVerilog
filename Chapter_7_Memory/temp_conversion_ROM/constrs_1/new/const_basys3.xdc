set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
# Switches
set_property PACKAGE_PIN V17 [get_ports format]					
	set_property IOSTANDARD LVCMOS33 [get_ports format]

#Temp input
set_property PACKAGE_PIN V16 [get_ports {temp_input[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[0]}]
set_property PACKAGE_PIN W16 [get_ports {temp_input[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[1]}]
set_property PACKAGE_PIN W17 [get_ports {temp_input[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[2]}]
set_property PACKAGE_PIN W15 [get_ports {temp_input[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[3]}]
set_property PACKAGE_PIN V15 [get_ports {temp_input[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[4]}]
set_property PACKAGE_PIN W14 [get_ports {temp_input[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[5]}]
set_property PACKAGE_PIN W13 [get_ports {temp_input[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[6]}]
set_property PACKAGE_PIN V2 [get_ports {temp_input[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_input[7]}]
	
#LEd outputs
# LEDs
set_property PACKAGE_PIN U16 [get_ports {temp_out[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[0]}]
set_property PACKAGE_PIN E19 [get_ports {temp_out[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[1]}]
set_property PACKAGE_PIN U19 [get_ports {temp_out[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[2]}]
set_property PACKAGE_PIN V19 [get_ports {temp_out[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[3]}]
set_property PACKAGE_PIN W18 [get_ports {temp_out[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[4]}]
set_property PACKAGE_PIN U15 [get_ports {temp_out[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[5]}]
set_property PACKAGE_PIN U14 [get_ports {temp_out[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[6]}]
set_property PACKAGE_PIN V14 [get_ports {temp_out[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {temp_out[7]}]
