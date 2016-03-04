onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/plif/tick
add wave -noupdate /system_tb/syif/addr
add wave -noupdate /system_tb/syif/store
add wave -noupdate /system_tb/syif/load
add wave -noupdate /system_tb/syif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/plif/lw_hazard
add wave -noupdate /system_tb/DUT/CPU/DP/plif/lw_later_hazard
add wave -noupdate /system_tb/DUT/CPU/DP/plif/branching
add wave -noupdate -divider PC
add wave -noupdate /system_tb/DUT/CPU/DP/n_pc_p4
add wave -noupdate /system_tb/DUT/CPU/DP/n_pc_j
add wave -noupdate /system_tb/DUT/CPU/DP/n_pc_reg
add wave -noupdate /system_tb/DUT/CPU/DP/n_pc_br
add wave -noupdate -divider Ram
add wave -noupdate /system_tb/DUT/prif/ramREN
add wave -noupdate /system_tb/DUT/prif/ramWEN
add wave -noupdate /system_tb/DUT/prif/ramaddr
add wave -noupdate /system_tb/DUT/prif/ramstore
add wave -noupdate /system_tb/DUT/prif/ramload
add wave -noupdate /system_tb/DUT/prif/ramstate
add wave -noupdate -divider ALU
add wave -noupdate /system_tb/DUT/CPU/DP/alif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/alif/OutputPort
add wave -noupdate /system_tb/DUT/CPU/DP/alif/Negative
add wave -noupdate /system_tb/DUT/CPU/DP/alif/Overflow
add wave -noupdate -divider RF
add wave -noupdate /system_tb/DUT/CPU/DP/RF/regs
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -divider HZ
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/src1_req_reg
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/src2_req_reg
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/forward1_set_reg
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/forward2_set_reg
add wave -noupdate /system_tb/DUT/CPU/CM/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/CM/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/pipeline_tick
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/src1_hazard_t
add wave -noupdate /system_tb/DUT/CPU/DP/HZ/hzif/src2_hazard_t
add wave -noupdate -divider IF
add wave -noupdate /system_tb/DUT/CPU/DP/PR/IF_Instr
add wave -noupdate /system_tb/DUT/CPU/DP/PR/IF_NPC
add wave -noupdate -divider ID
add wave -noupdate /system_tb/DUT/CPU/DP/plif/branching
add wave -noupdate /system_tb/DUT/CPU/DP/alif/PortA
add wave -noupdate /system_tb/DUT/CPU/DP/alif/PortB
add wave -noupdate /system_tb/DUT/CPU/DP/alif/Zero
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_NPC
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_Instr
add wave -noupdate /system_tb/DUT/CPU/DP/plif/ID_Instr_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_jump_t
add wave -noupdate /system_tb/DUT/CPU/DP/plif/ID_jump_t_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_RegDst_t
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_ALUSrc1
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_ALUSrc2
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_careOF
add wave -noupdate /system_tb/DUT/CPU/DP/PR/ID_halt
add wave -noupdate -divider EX
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_InstrReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_NPC
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_jump_t
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_Result
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_Wdata
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_RegDst
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP/PR/EX_halt
add wave -noupdate -divider MEM
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_InstrReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_NPC
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_ReadData
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_CalcData
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_RegDst
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP/plif/MEM_halt_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/PR/MEM_halt
add wave -noupdate /system_tb/DUT/CPU/DP/RF/regs
add wave -noupdate -divider cache
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/dREN
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/dWEN
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/iload
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/dload
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/iaddr
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/daddr
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/ramREN
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/ramstate
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/ramstore
add wave -noupdate /system_tb/DUT/CPU/CM/ccif/ramload
add wave -noupdate -divider ICA
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/icacheReg
add wave -noupdate -divider DCA
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/CM/DCACHE/hitT
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/d_state
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dcacheReg
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /system_tb/DUT/CPU/DP/pcEN
add wave -noupdate /system_tb/DUT/CPU/DP/pc
add wave -noupdate /system_tb/DUT/CPU/DP/n_pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5135472 ps} 0}
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
WaveRestoreZoom {5101 ns} {5199 ns}
