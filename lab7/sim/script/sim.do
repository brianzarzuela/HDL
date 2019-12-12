vlib work
vmap altera_mf ../../src/altera_mf
vcom -93 -work work ../../src/rom/calculator_rom.vhd
vcom -93 -work work ../../src/alu.vhd
vcom -93 -work work ../../src/bcd_to_seven_seg.vhd
vcom -93 -work work ../../src/calculator.vhd
vcom -93 -work work ../../src/calculator_mem.vhd
vcom -93 -work work ../../src/components.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/memory.vhd
vcom -93 -work work ../../src/rising_edge_syncrhonizer.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/top.vhd
vcom -93 -work work ../src/top_tb.vhd
vsim -voptargs=+acc top_tb
do wave.do
run 1500 ns
