vlib work
vcom -93 -work work ../../src/bcd_to_seven_seg.vhd
vcom -93 -work work ../../src/components.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/gen_add_sub.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/add_sub_state_machine.vhd
vcom -93 -work work ../src/add_sub_state_machine_tb.vhd
vsim -voptargs=+acc add_sub_state_machine_tb
do wave.do
run 700 ns
