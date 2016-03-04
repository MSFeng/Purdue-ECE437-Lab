onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate -divider ccif
add wave -noupdate /dcache_tb/ccif/dwait
add wave -noupdate /dcache_tb/ccif/dREN
add wave -noupdate /dcache_tb/ccif/dWEN
add wave -noupdate /dcache_tb/ccif/dload
add wave -noupdate /dcache_tb/ccif/dstore
add wave -noupdate /dcache_tb/ccif/daddr
add wave -noupdate /dcache_tb/ccif/ccwait
add wave -noupdate /dcache_tb/ccif/ccwrite
add wave -noupdate -divider dcif
add wave -noupdate /dcache_tb/dcif/halt
add wave -noupdate /dcache_tb/dcif/dhit
add wave -noupdate /dcache_tb/dcif/dmemREN
add wave -noupdate /dcache_tb/dcif/dmemWEN
add wave -noupdate /dcache_tb/dcif/flushed
add wave -noupdate /dcache_tb/dcif/dmemload
add wave -noupdate /dcache_tb/dcif/dmemstore
add wave -noupdate /dcache_tb/dcif/dmemaddr
add wave -noupdate -divider dcache
add wave -noupdate /dcache_tb/DUT/dcache
add wave -noupdate /dcache_tb/DUT/n_dcache
add wave -noupdate /dcache_tb/DUT/d_state
add wave -noupdate /dcache_tb/DUT/n_d_state
add wave -noupdate /dcache_tb/DUT/d_tag
add wave -noupdate /dcache_tb/DUT/d_index
add wave -noupdate /dcache_tb/DUT/d_tag_chk_0
add wave -noupdate /dcache_tb/DUT/d_tag_chk_1
add wave -noupdate /dcache_tb/DUT/d_valid_chk_0
add wave -noupdate /dcache_tb/DUT/d_valid_chk_1
add wave -noupdate /dcache_tb/DUT/d_dirty_chk_0
add wave -noupdate /dcache_tb/DUT/d_dirty_chk_1
add wave -noupdate /dcache_tb/DUT/d_data_stored_0
add wave -noupdate /dcache_tb/DUT/d_data_stored_1
add wave -noupdate /dcache_tb/DUT/d_data_stored
add wave -noupdate /dcache_tb/DUT/d_same_tag
add wave -noupdate /dcache_tb/DUT/d_acc_map
add wave -noupdate /dcache_tb/DUT/n_d_acc_map
add wave -noupdate /dcache_tb/DUT/d_other_addr
add wave -noupdate /dcache_tb/DUT/halt
add wave -noupdate /dcache_tb/DUT/hitT
add wave -noupdate /dcache_tb/DUT/n_hitT
add wave -noupdate /dcache_tb/DUT/d_count
add wave -noupdate /dcache_tb/DUT/n_d_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61171374 ns} 0}
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
WaveRestoreZoom {61171215 ns} {61172215 ns}
