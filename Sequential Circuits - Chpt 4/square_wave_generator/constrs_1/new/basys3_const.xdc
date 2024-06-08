# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

#wave output to PMOD JB - pin 1
set_property PACKAGE_PIN A14 [get_ports wave_out]					
	set_property IOSTANDARD LVCMOS33 [get_ports wave_out]
	
#INput values - switches
set_property PACKAGE_PIN V17 [get_ports {on_period[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {on_period[0]}]
set_property PACKAGE_PIN V16 [get_ports {on_period[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {on_period[1]}]
set_property PACKAGE_PIN W16 [get_ports {on_period[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {on_period[2]}]
set_property PACKAGE_PIN W17 [get_ports {on_period[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {on_period[3]}]
set_property PACKAGE_PIN W15 [get_ports {off_period[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {off_period[0]}]
set_property PACKAGE_PIN V15 [get_ports {off_period[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {off_period[1]}]
set_property PACKAGE_PIN W14 [get_ports {off_period[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {off_period[2]}]
set_property PACKAGE_PIN W13 [get_ports {off_period[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {off_period[3]}]

	
	
#Reset Value
set_property PACKAGE_PIN R2 [get_ports reset]					
	set_property IOSTANDARD LVCMOS33 [get_ports reset]