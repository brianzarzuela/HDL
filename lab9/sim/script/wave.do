onerror {resume}
radix define Instructions {
    "8'b00010?????" "Play 0" -color "green",
    "8'b00100?????" "Play 1" -color "green",
    "8'b00011?????" "Play 0 Repeat" -color "purple",
    "8'b00101?????" "Play 1 Repeat" -color "purple",
    "8'b00111?????" "Play 0/1 Repeat" -color "purple",
    "8'b01????????" "Pause" -color "orange",
    "8'b10????????" "Seek" -color "blue",
    "8'b11????????" "Stop" -color "red",
    -default hexadecimal
    -defaultcolor white
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/clk
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/reset
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/sync
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/execute_btn
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/data_address_0
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/data_address_1
add wave -noupdate -radix unsigned /dj_roomba_3000_tb/dj_roomba/pc
add wave -noupdate -radix Instructions /dj_roomba_3000_tb/dj_roomba/instruction
add wave -noupdate -expand -group uut -format Analog-Step -height 74 -max 1492.0 /dj_roomba_3000_tb/dj_roomba/ch0_audio
add wave -noupdate -expand -group uut -format Analog-Step -height 74 -max 1492.0 /dj_roomba_3000_tb/dj_roomba/ch1_audio
add wave -noupdate -expand -group uut -format Analog-Step -height 74 -max 1492.0 /dj_roomba_3000_tb/dj_roomba/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3750040 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
configure wave -valuecolwidth 180
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {21 ms}
