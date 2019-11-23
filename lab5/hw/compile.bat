quartus_sh -t compile.tcl
pause

quartus_pgm --mode=JTAG -o P;output_files\add_sub_state_machine.sof@2
pause