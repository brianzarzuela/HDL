onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0010000" "9" -color "red",
    "5'b00001" "read_w"        -color "red",
    "5'b00010" "read_s"        -color "red",
    "5'b00100" "write_w"       -color "red",
    "5'b01000" "write_s"       -color "red",
    "5'b10000" "write_w_no_op" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/uut/clk
add wave -noupdate /top_tb/uut/reset
add wave -noupdate /top_tb/uut/switch
add wave -noupdate /top_tb/uut/execute
add wave -noupdate /top_tb/uut/ms
add wave -noupdate /top_tb/uut/mr
add wave -noupdate -radix States /top_tb/uut/hundreds
add wave -noupdate -radix States /top_tb/uut/tens
add wave -noupdate -radix States /top_tb/uut/ones
add wave -noupdate -radix States /top_tb/uut/led
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1500 ns}
