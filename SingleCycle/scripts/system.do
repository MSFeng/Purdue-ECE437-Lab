onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/syif/addr
add wave -noupdate /system_tb/syif/store
add wave -noupdate /system_tb/syif/load
add wave -noupdate /system_tb/syif/halt
add wave -noupdate -divider RamInfo
add wave -noupdate /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -divider MR
add wave -noupdate /system_tb/DUT/CPU/DP/MR/mrif/MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP/MR/mrif/MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP/MR/mrif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/MR/mrif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/MR/mrif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/DP/MR/mrif/dmemWEN
add wave -noupdate -divider Cache
add wave -noupdate -divider {Control Unit}
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Instr
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/jump_t
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/RegDst_t
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/RegWen
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUSrc_t
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/careOF
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -divider {Memory Control}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {477876460 ps} 0}
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
WaveRestoreZoom {0 ps} {1377852 ns}
