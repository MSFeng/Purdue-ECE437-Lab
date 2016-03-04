onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /coherency_control_tb/CLK
add wave -noupdate /coherency_control_tb/nRST
add wave -noupdate /coherency_control_tb/snoopMatch
add wave -noupdate /coherency_control_tb/DUT/state
add wave -noupdate /coherency_control_tb/DUT/n_state
add wave -noupdate /coherency_control_tb/ccif/iwait
add wave -noupdate /coherency_control_tb/ccif/dwait
add wave -noupdate /coherency_control_tb/ccif/iREN
add wave -noupdate /coherency_control_tb/ccif/dREN
add wave -noupdate /coherency_control_tb/ccif/dWEN
add wave -noupdate /coherency_control_tb/ccif/iload
add wave -noupdate /coherency_control_tb/ccif/dload
add wave -noupdate /coherency_control_tb/ccif/dstore
add wave -noupdate /coherency_control_tb/ccif/iaddr
add wave -noupdate /coherency_control_tb/ccif/daddr
add wave -noupdate /coherency_control_tb/ccif/ccwait
add wave -noupdate /coherency_control_tb/ccif/ccinv
add wave -noupdate /coherency_control_tb/ccif/ccwrite
add wave -noupdate /coherency_control_tb/ccif/cctrans
add wave -noupdate /coherency_control_tb/ccif/ccsnoopaddr
add wave -noupdate /coherency_control_tb/ccif/ccinvdone
add wave -noupdate /coherency_control_tb/ccif/ccwb
add wave -noupdate /coherency_control_tb/ccif/ccwbdone
add wave -noupdate /coherency_control_tb/ccif/ramWEN
add wave -noupdate /coherency_control_tb/ccif/ramREN
add wave -noupdate /coherency_control_tb/ccif/ramstate
add wave -noupdate /coherency_control_tb/ccif/ramaddr
add wave -noupdate /coherency_control_tb/ccif/ramstore
add wave -noupdate /coherency_control_tb/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {83 ns} 0}
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
WaveRestoreZoom {0 ns} {198 ns}
