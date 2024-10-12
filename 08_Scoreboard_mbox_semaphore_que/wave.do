onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fifo/clk
add wave -noupdate /tb_fifo/rst_n
add wave -noupdate /tb_fifo/wr_en
add wave -noupdate /tb_fifo/rd_en
add wave -noupdate /tb_fifo/wr_data
add wave -noupdate /tb_fifo/rd_data
add wave -noupdate /tb_fifo/full
add wave -noupdate /tb_fifo/empty
add wave -noupdate /tb_fifo/transactions
add wave -noupdate /tb_fifo/errors
add wave -noupdate /tb_fifo/producer/data
add wave -noupdate /tb_fifo/consumer/transactions
add wave -noupdate /tb_fifo/consumer/errors
add wave -noupdate /tb_fifo/consumer/data
add wave -noupdate /tb_fifo/uut/clk
add wave -noupdate /tb_fifo/uut/rst_n
add wave -noupdate /tb_fifo/uut/wr_en
add wave -noupdate /tb_fifo/uut/rd_en
add wave -noupdate /tb_fifo/uut/wr_data
add wave -noupdate /tb_fifo/uut/rd_data
add wave -noupdate /tb_fifo/uut/full
add wave -noupdate /tb_fifo/uut/empty
add wave -noupdate /tb_fifo/uut/wr_ptr
add wave -noupdate /tb_fifo/uut/rd_ptr
add wave -noupdate /tb_fifo/uut/count
add wave -noupdate -expand /tb_fifo/uut/fifo_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {636 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 73
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
WaveRestoreZoom {0 ns} {352 ns}
