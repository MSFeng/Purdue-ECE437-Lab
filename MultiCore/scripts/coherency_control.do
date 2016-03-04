onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /coherency_control_tb/CLK
add wave -noupdate /coherency_control_tb/nRST
add wave -noupdate /coherency_control_tb/snoopMatch
add wave -noupdate /coherency_control_tb/DUT/state
add wave -noupdate -expand /coherency_control_tb/PROG/ccif/dREN
add wave -noupdate /coherency_control_tb/PROG/ccif/ccwait
add wave -noupdate /coherency_control_tb/PROG/ccif/ccinv
add wave -noupdate /coherency_control_tb/PROG/ccif/ccwrite
add wave -noupdate /coherency_control_tb/PROG/ccif/cctrans
add wave -noupdate /coherency_control_tb/PROG/ccif/ccsnoopaddr
add wave -noupdate /coherency_control_tb/PROG/ccif/ccinvdone
add wave -noupdate /coherency_control_tb/PROG/ccif/ccwb
add wave -noupdate /coherency_control_tb/PROG/ccif/ccwbdone
add wave -noupdate /coherency_control_tb/PROG/ccif/ramstate
add wave -noupdate /coherency_control_tb/PROG/ccif/ramaddr
add wave -noupdate /coherency_control_tb/PROG/ccif/ramstore
add wave -noupdate /coherency_control_tb/PROG/ccif/ramload
add wave -noupdate /coherency_control_tb/ccif/dWEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {71 ns}
