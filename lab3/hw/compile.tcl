# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "counter"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/bcd_to_seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_adder_beh.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/components.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd

set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to reset

set_location_assignment PIN_AE26 -to display[0]
set_location_assignment PIN_AE27 -to display[1]
set_location_assignment PIN_AE28 -to display[2]
set_location_assignment PIN_AG27 -to display[3]
set_location_assignment PIN_AF28 -to display[4]
set_location_assignment PIN_AG28 -to display[5]
set_location_assignment PIN_AH28 -to display[6]


execute_flow -compile
project_close