# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "calculator"

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
set_global_assignment -name VHDL_FILE ../../src/synchronizer_8bit.vhd
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/double_dabble.vhd
set_global_assignment -name VHDL_FILE ../../src/memory.vhd
set_global_assignment -name VHDL_FILE ../../src/components.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd

set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to reset
set_location_assignment PIN_AA15 -to mr
set_location_assignment PIN_W15  -to ms
set_location_assignment PIN_Y16  -to execute

# set_location_assignment PIN_V16  -to led[0]
# set_location_assignment PIN_W16  -to led[1]
# set_location_assignment PIN_V17  -to led[2]
# set_location_assignment PIN_V18  -to led[3]
# set_location_assignment PIN_W17  -to led[3]

set_location_assignment PIN_AB12 -to switch[0]
set_location_assignment PIN_AC12 -to switch[1]
set_location_assignment PIN_AF9  -to switch[2]
set_location_assignment PIN_AF10 -to switch[3]
set_location_assignment PIN_AD11 -to switch[4]
set_location_assignment PIN_AD12 -to switch[5]
set_location_assignment PIN_AE11 -to switch[6]
set_location_assignment PIN_AC9  -to switch[7]

set_location_assignment PIN_AD10 -to opcode[0]
set_location_assignment PIN_AE12 -to opcode[1]

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

# set_location_assignment PIN_AD26 -to bcd_3[0]
# set_location_assignment PIN_AC27 -to bcd_3[1]
# set_location_assignment PIN_AD25 -to bcd_3[2]
# set_location_assignment PIN_AC25 -to bcd_3[3]
# set_location_assignment PIN_AB28 -to bcd_3[4]
# set_location_assignment PIN_AB25 -to bcd_3[5]
# set_location_assignment PIN_AB22 -to bcd_3[6]

# set_location_assignment PIN_AA24 -to bcd_4[0]
# set_location_assignment PIN_Y23  -to bcd_4[1]
# set_location_assignment PIN_Y24  -to bcd_4[2]
# set_location_assignment PIN_W22  -to bcd_4[3]
# set_location_assignment PIN_W24  -to bcd_4[4]
# set_location_assignment PIN_V23  -to bcd_4[5]
# set_location_assignment PIN_W25  -to bcd_4[6]

# set_location_assignment PIN_V25  -to bcd_5[0]
# set_location_assignment PIN_AA28 -to bcd_5[1]
# set_location_assignment PIN_Y27  -to bcd_5[2]
# set_location_assignment PIN_AB27 -to bcd_5[3]
# set_location_assignment PIN_AB26 -to bcd_5[4]
# set_location_assignment PIN_AA26 -to bcd_5[5]
# set_location_assignment PIN_AA25 -to bcd_5[6]

execute_flow -compile
project_close