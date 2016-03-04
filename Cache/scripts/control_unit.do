onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/cuif/Instr
add wave -noupdate /control_unit_tb/cuif/jump_t
add wave -noupdate /control_unit_tb/cuif/RegDst_t
add wave -noupdate /control_unit_tb/cuif/RegWen
add wave -noupdate /control_unit_tb/cuif/ALUSrc_t
add wave -noupdate /control_unit_tb/cuif/ALUOP
add wave -noupdate /control_unit_tb/cuif/MemToReg
add wave -noupdate /control_unit_tb/cuif/PcToReg
add wave -noupdate /control_unit_tb/cuif/MemWrite
add wave -noupdate /control_unit_tb/cuif/careOF
add wave -noupdate /control_unit_tb/cuif/halt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12 ns} 0}
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
WaveRestoreZoom {9 ns} {25 ns}
