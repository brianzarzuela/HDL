vlib work
vcom -93 -work work ../../src/adder_single_bit_behavioral_pkg.vhd
vcom -93 -work work ../src/adder_single_bit_behavioral_tb.vhd
vsim  -voptargs=+acc=rnbp adder_single_bit_behavioral_tb
do wave.do
run 500 ns
