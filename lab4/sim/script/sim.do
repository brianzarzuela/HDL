vlib work
vcom -93 -work work ../../src/bcd_to_seven_seg.vhd
vcom -93 -work work ../../src/gen_add_sub.vhd
vcom -93 -work work ../../src/gen_synchronizer.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/components.vhd
vcom -93 -work work ../../src/top.vhd
vcom -93 -work work ../src/top_tb.vhd
vsim -voptargs=+acc top_tb
do wave.do
run 15000 ns
