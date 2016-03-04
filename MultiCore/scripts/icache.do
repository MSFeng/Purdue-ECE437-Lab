onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate -divider ccif
add wave -noupdate /icache_tb/DUT/ccif/iwait
add wave -noupdate /icache_tb/DUT/ccif/dwait
add wave -noupdate /icache_tb/DUT/ccif/iREN
add wave -noupdate /icache_tb/DUT/ccif/dREN
add wave -noupdate /icache_tb/DUT/ccif/dWEN
add wave -noupdate /icache_tb/DUT/ccif/iload
add wave -noupdate /icache_tb/DUT/ccif/dload
add wave -noupdate /icache_tb/DUT/ccif/dstore
add wave -noupdate /icache_tb/DUT/ccif/iaddr
add wave -noupdate /icache_tb/DUT/ccif/ramstate
add wave -noupdate /icache_tb/DUT/ccif/iwait
add wave -noupdate /icache_tb/DUT/ccif/iload
add wave -noupdate /icache_tb/DUT/ccif/iREN
add wave -noupdate /icache_tb/DUT/ccif/iaddr
add wave -noupdate -divider dcif
add wave -noupdate /icache_tb/DUT/dcif/halt
add wave -noupdate /icache_tb/DUT/dcif/ihit
add wave -noupdate /icache_tb/DUT/dcif/imemREN
add wave -noupdate /icache_tb/DUT/dcif/imemload
add wave -noupdate /icache_tb/DUT/dcif/imemaddr
add wave -noupdate -divider ICACHE
add wave -noupdate /icache_tb/DUT/instr
add wave -noupdate /icache_tb/DUT/icache
add wave -noupdate /icache_tb/DUT/n_icache
add wave -noupdate /icache_tb/DUT/i_tag
add wave -noupdate /icache_tb/DUT/i_index
add wave -noupdate /icache_tb/DUT/i_tag_chk
add wave -noupdate /icache_tb/DUT/i_valid_chk
add wave -noupdate /icache_tb/DUT/i_same_tag
add wave -noupdate /icache_tb/DUT/i_data_stored
add wave -noupdate /icache_tb/DUT/dcif/dmemaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {169 ns} 0}
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
WaveRestoreZoom {0 ns} {292 ns}
