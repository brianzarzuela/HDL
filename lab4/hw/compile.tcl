# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "add_sub"

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
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/gen_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/bcd_to_seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/gen_add_sub.vhd
set_global_assignment -name VHDL_FILE ../../src/components.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd

set_location_assignment PIN_AB12 -to reset
set_location_assignment PIN_AF14 -to clk

set_location_assignment PIN_Y16  -to add_btn
set_location_assignment PIN_W15  -to sub_btn

set_location_assignment PIN_AD11 -to b[0]
set_location_assignment PIN_AD12 -to b[1]
set_location_assignment PIN_AE11 -to b[2]
set_location_assignment PIN_AC9  -to a[0]
set_location_assignment PIN_AD10 -to a[1]
set_location_assignment PIN_AE12 -to a[2]

set_location_assignment PIN_AE26 -to result_ssd[0]
set_location_assignment PIN_AE27 -to result_ssd[1]
set_location_assignment PIN_AE28 -to result_ssd[2]
set_location_assignment PIN_AG27 -to result_ssd[3]
set_location_assignment PIN_AF28 -to result_ssd[4]
set_location_assignment PIN_AG28 -to result_ssd[5]
set_location_assignment PIN_AH28 -to result_ssd[6]

set_location_assignment PIN_AJ29 -to b_ssd[0]
set_location_assignment PIN_AH29 -to b_ssd[1]
set_location_assignment PIN_AH30 -to b_ssd[2]
set_location_assignment PIN_AG30 -to b_ssd[3]
set_location_assignment PIN_AF29 -to b_ssd[4]
set_location_assignment PIN_AF30 -to b_ssd[5]
set_location_assignment PIN_AD27 -to b_ssd[6]

set_location_assignment PIN_AB23 -to a_ssd[0]
set_location_assignment PIN_AE29 -to a_ssd[1]
set_location_assignment PIN_AD29 -to a_ssd[2]
set_location_assignment PIN_AC28 -to a_ssd[3]
set_location_assignment PIN_AD30 -to a_ssd[4]
set_location_assignment PIN_AC29 -to a_ssd[5]
set_location_assignment PIN_AC30 -to a_ssd[6]

execute_flow -compile
project_close