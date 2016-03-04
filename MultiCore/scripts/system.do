onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider DataPath
add wave -noupdate -divider D0
add wave -noupdate /system_tb/DUT/CPU/DP0/halt_reg
add wave -noupdate /system_tb/DUT/CPU/DP0/pc
add wave -noupdate /system_tb/DUT/CPU/DP0/n_pc
add wave -noupdate /system_tb/DUT/CPU/DP0/cuif/Instr
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate -divider D1
add wave -noupdate /system_tb/DUT/CPU/DP1/halt_reg
add wave -noupdate /system_tb/DUT/CPU/DP1/pc
add wave -noupdate /system_tb/DUT/CPU/DP1/cuif/Instr
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dhit
add wave -noupdate -divider Caches
add wave -noupdate -divider C_I0
add wave -noupdate /system_tb/DUT/CPU/CM0/ICACHE/CPUID
add wave -noupdate /system_tb/DUT/CPU/CM0/ICACHE/instr
add wave -noupdate /system_tb/DUT/CPU/CM0/ICACHE/icacheReg
add wave -noupdate -divider C_I1
add wave -noupdate /system_tb/DUT/CPU/CM1/ICACHE/CPUID
add wave -noupdate /system_tb/DUT/CPU/CM1/ICACHE/instr
add wave -noupdate /system_tb/DUT/CPU/CM1/ICACHE/icacheReg
add wave -noupdate -divider C_D0
add wave -noupdate /system_tb/DUT/CPU/DP0/HZ/hzif/src1_hazard_t
add wave -noupdate /system_tb/DUT/CPU/DP0/HZ/hzif/src2_hazard_t
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dmemload
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/datomic
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/datomicSTATE
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/canstore
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/linkReg
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/link_valid
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/ccatomicinvalidate
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/ccatomicinvalidating
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/ccatomicaddr
add wave -noupdate /system_tb/DUT/CPU/CC/dmemaddr0
add wave -noupdate /system_tb/DUT/CPU/DP1/plif/ID_MemWrite_OUT
add wave -noupdate /system_tb/DUT/CPU/DP1/plif/EX_MemWrite_OUT
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/CPUID
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/ccinv
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_tag
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_tag_chk_0
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_tag_chk_1
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/snoop_same_tag
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/d_state
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/d_count
add wave -noupdate /system_tb/DUT/CPU/DP0/RF/regs
add wave -noupdate -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/dcacheReg[0]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/dcacheReg
add wave -noupdate -divider C_D1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/CPUID
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/ccinv
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/DP1/hzif/src1_hazard_t
add wave -noupdate /system_tb/DUT/CPU/DP1/hzif/src2_hazard_t
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/snoop_same_tag
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_state
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_count
add wave -noupdate /system_tb/DUT/CPU/DP1/RF/regs
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/canstore
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/link_valid
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/linkReg
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/ccatomicinvalidate
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/ccatomicinvalidating
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/ccatomicaddr
add wave -noupdate /system_tb/DUT/CPU/CC/dmemaddr1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_same_tag
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_index
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_tag_chk_0
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_tag_chk_1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_valid_chk_0
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_valid_chk_1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_dirty_chk_0
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_dirty_chk_1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_data_stored_0
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/d_data_stored_1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/cccofreetomove
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dload
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dstore
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/n_dcacheReg
add wave -noupdate -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/dcacheReg[0]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/dcacheReg
add wave -noupdate -divider {Memory Control}
add wave -noupdate /system_tb/DUT/CPU/CC/mytask
add wave -noupdate -expand /system_tb/DUT/CPU/CM0/ccif/iload
add wave -noupdate /system_tb/DUT/CPU/CM0/ccif/dload
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate -divider {Coherency Control}
add wave -noupdate /system_tb/DUT/CPU/CC/COC/state
add wave -noupdate /system_tb/DUT/CPU/CC/COC/snoopaddr0
add wave -noupdate /system_tb/DUT/CPU/CC/COC/snoopaddr1
add wave -noupdate -expand /system_tb/DUT/CPU/CC/COC/snoopingTag
add wave -noupdate -divider ccif
add wave -noupdate /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate /system_tb/DUT/CPU/ccif/iload
add wave -noupdate /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/ccif/ccsnoopchecking
add wave -noupdate /system_tb/DUT/CPU/ccif/ccsnoopvalue
add wave -noupdate /system_tb/DUT/CPU/ccif/ccsnoopvalid
add wave -noupdate /system_tb/DUT/CPU/ccif/ccatomicinvalidating
add wave -noupdate /system_tb/DUT/CPU/ccif/ccatomicaddr
add wave -noupdate /system_tb/DUT/CPU/ccif/ccatomicinvalidate
add wave -noupdate /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate /system_tb/DUT/CPU/ccif/ramload
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider DP0
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/ID_NPC
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/ID_careOF
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/ID_Instr
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/ID_ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP0/alif/PortA
add wave -noupdate /system_tb/DUT/CPU/DP0/alif/PortB
add wave -noupdate /system_tb/DUT/CPU/DP0/alif/OutputPort
add wave -noupdate /system_tb/DUT/CPU/DP0/alif/Zero
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/ID_jump_t
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_InstrReg
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_NPC
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_jump_t
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_Result
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_Wdata
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_RegDst
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/EX_halt
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_InstrReg
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_NPC
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_ReadData
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_CalcData
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_RegDst
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP0/PR/MEM_halt
add wave -noupdate /system_tb/DUT/CPU/DP0/plif/MEM_Atomic_OUT
add wave -noupdate /system_tb/DUT/CPU/DP0/plif/MEM_AtomicSTATE_OUT
add wave -noupdate -divider DP1
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/ID_careOF
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_InstrReg
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_NPC
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_jump_t
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_Result
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_Wdata
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_RegDst
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/EX_halt
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_InstrReg
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_PcToReg
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_NPC
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_ReadData
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_CalcData
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_RegDst
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_RegWen
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_MemToReg
add wave -noupdate /system_tb/DUT/CPU/DP1/PR/MEM_halt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {890464 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 178
configure wave -valuecolwidth 201
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
WaveRestoreZoom {739 ns} {1857 ns}
