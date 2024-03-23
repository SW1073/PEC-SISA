cd /home/usuari/test_files

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {./package_timing.vhd}
vcom -93 -work work {./package_utility.vhd}
vcom -93 -work work {./async_64Kx16.vhd}
vcom -93 -work work {./test_sisa.vhd}

vcom -93 -work work {../proc/alu/op_arit_log.vhd}
vcom -93 -work work {../proc/alu/op_comp.vhd}
vcom -93 -work work {../proc/alu/op_ext_arit.vhd}
vcom -93 -work work {../proc/alu/op_immed.vhd}
vcom -93 -work work {../proc/alu/op_movs.vhd}
vcom -93 -work work {../driver7Segmentos.vhd}
vcom -93 -work work {../sisa.vhd}
vcom -93 -work work {../mem_ctrl/SRAMController.vhd}
vcom -93 -work work {../mem_ctrl/MemoryController.vhd}
vcom -93 -work work {../proc/alu/alu.vhd}
vcom -93 -work work {../proc/banco_regs/regfile.vhd}
vcom -93 -work work {../proc/datapath/datapath.vhd}
vcom -93 -work work {../proc/uc/unidad_control.vhd}
vcom -93 -work work {../proc/uc/multi.vhd}
vcom -93 -work work {../proc/uc/control_l.vhd}
vcom -93 -work work {../proc/proc.vhd}

vsim work.test_sisa

do wave.do
run 12100ns
