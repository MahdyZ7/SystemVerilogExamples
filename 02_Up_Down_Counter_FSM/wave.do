onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_up_down_counter/clk
add wave -noupdate /tb_up_down_counter/reset
add wave -noupdate /tb_up_down_counter/up_down
add wave -noupdate /tb_up_down_counter/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {986 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {168 ns}
