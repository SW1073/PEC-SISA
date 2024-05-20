pwd

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

do compile.tcl

vsim work.test_illegal_ir

do wave.tcl
run 1320 us
