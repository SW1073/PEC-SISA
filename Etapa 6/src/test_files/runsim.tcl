cd /home/usuari/test_files

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

do compile.tcl

vsim work.test_sisa

do wave.tcl
run 12100ns
