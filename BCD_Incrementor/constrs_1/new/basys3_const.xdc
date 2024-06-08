# Constraints for Basys 3 Board
# Set up the bottom 8 switches as inputs
set_property PACKAGE_PIN V17 [get_ports {input_value[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[0]}]

set_property PACKAGE_PIN V16 [get_ports {input_value[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[1]}]

set_property PACKAGE_PIN W16 [get_ports {input_value[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[2]}]

set_property PACKAGE_PIN W17 [get_ports {input_value[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[3]}]

set_property PACKAGE_PIN W15 [get_ports {input_value[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[4]}]

set_property PACKAGE_PIN V15 [get_ports {input_value[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[5]}]

set_property PACKAGE_PIN W14 [get_ports {input_value[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[6]}]

set_property PACKAGE_PIN W13 [get_ports {input_value[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_value[7]}]

# Top right 8 LED's
set_property PACKAGE_PIN U16 [get_ports {out[0][0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[0][0]}]

set_property PACKAGE_PIN E19 [get_ports {out[0][1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[0][1]}]

set_property PACKAGE_PIN U19 [get_ports {out[0][2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[0][2]}]

set_property PACKAGE_PIN V19 [get_ports {out[0][3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[0][3]}]

set_property PACKAGE_PIN W18 [get_ports {out[1][0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[1][0]}]

set_property PACKAGE_PIN U15 [get_ports {out[1][1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[1][1]}]

set_property PACKAGE_PIN U14 [get_ports {out[1][2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[1][2]}]

set_property PACKAGE_PIN V14 [get_ports {out[1][3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[1][3]}]

