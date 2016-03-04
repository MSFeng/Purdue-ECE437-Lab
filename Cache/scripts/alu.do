onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/CLK
add wave -noupdate /alu_tb/nRST
add wave -noupdate /alu_tb/aluif/ALUOP
add wave -noupdate /alu_tb/aluif/PortA
add wave -noupdate /alu_tb/aluif/PortB
add wave -noupdate /alu_tb/aluif/OutputPort
add wave -noupdate /alu_tb/aluif/Negative
add wave -noupdate /alu_tb/aluif/Overflow
add wave -noupdate /alu_tb/aluif/Zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {135218 ps} 0}
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
WaveRestoreZoom {135050 ps} {136050 ps}
