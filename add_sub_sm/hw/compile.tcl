# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "add_sub_state_machine"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY add_sub_state_machine
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/bcd_to_seven_seg.vhd
set_global_assignment -name VHDL_FILE ../../src/gen_add_sub.vhd
set_global_assignment -name VHDL_FILE ../../src/synchronizer_8bit.vhd
set_global_assignment -name VHDL_FILE ../../src/double_dabble.vhd
set_global_assignment -name VHDL_FILE ../../src/components.vhd
set_global_assignment -name VHDL_FILE ../../src/add_sub_state_machine.vhd

set_location_assignment PIN_AB12 -to reset
set_location_assignment PIN_AF14 -to clk
#set_location_assignment PIN_D25 -to clk

set_location_assignment PIN_V16  -to led[0]
set_location_assignment PIN_W16  -to led[1]
set_location_assignment PIN_V17  -to led[2]
set_location_assignment PIN_V18  -to led[3]

set_location_assignment PIN_AF9  -to switch[0]
set_location_assignment PIN_AF10 -to switch[1]
set_location_assignment PIN_AD11 -to switch[2]
set_location_assignment PIN_AD12 -to switch[3]
set_location_assignment PIN_AE11 -to switch[4]
set_location_assignment PIN_AC9  -to switch[5]
set_location_assignment PIN_AD10 -to switch[6]
set_location_assignment PIN_AE12 -to switch[7]

set_location_assignment PIN_AE26 -to ones[0]
set_location_assignment PIN_AE27 -to ones[1]
set_location_assignment PIN_AE28 -to ones[2]
set_location_assignment PIN_AG27 -to ones[3]
set_location_assignment PIN_AF28 -to ones[4]
set_location_assignment PIN_AG28 -to ones[5]
set_location_assignment PIN_AH28 -to ones[6]

set_location_assignment PIN_AJ29 -to tens[0]
set_location_assignment PIN_AH29 -to tens[1]
set_location_assignment PIN_AH30 -to tens[2]
set_location_assignment PIN_AG30 -to tens[3]
set_location_assignment PIN_AF29 -to tens[4]
set_location_assignment PIN_AF30 -to tens[5]
set_location_assignment PIN_AD27 -to tens[6]

set_location_assignment PIN_AB23 -to hundreds[0]
set_location_assignment PIN_AE29 -to hundreds[1]
set_location_assignment PIN_AD29 -to hundreds[2]
set_location_assignment PIN_AC28 -to hundreds[3]
set_location_assignment PIN_AD30 -to hundreds[4]
set_location_assignment PIN_AC29 -to hundreds[5]
set_location_assignment PIN_AC30 -to hundreds[6]

set_location_assignment PIN_AA14 -to btn

execute_flow -compile
project_close