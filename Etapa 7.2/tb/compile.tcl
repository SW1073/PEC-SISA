set SRC "../src"

# Compile packages, and things that do not generate any dependency
# async_64Kx16
vcom -93 -work work {./package_timing.vhd}
vcom -93 -work work {./package_utility.vhd}
# proc and sisa
vcom -93 -work work {../src/package_records.vhd}
vcom -93 -work work {../src/proc/packages/package_opcodes.vhd}
vcom -93 -work work {../src/proc/packages/package_alu.vhd}
vcom -93 -work work {../src/proc/packages/package_control.vhd}
vcom -93 -work work {../src/io_ctrl/package_io.vhd}


# IO controller and things inside it
vcom -93 -work work {../src/Controlador_PS2_Keyboard/ps2_keyboard.vhd}
vcom -93 -work work {../src/Controlador_PS2_Keyboard/keyboard_controller.vhd}
vcom -93 -work work {../src/io_ctrl/interrupt/interrupt_ctrl.vhd}
vcom -93 -work work {../src/io_ctrl/interrupt/timer_int_ctrl.vhd}
vcom -93 -work work {../src/io_ctrl/interrupt/key_sw_int_ctrl.vhd}
vcom -93 -work work {../src/io_ctrl/interrupt/keyboard_int_ctrl.vhd}
vcom -93 -work work {../src/io_ctrl/controladores_io.vhd}


# Memory controller and things inside it
vcom -93 -work work {../src/Controlador_VGA/Controlador_VGA1/vga_controller.vhd}
vcom -93 -work work {../src/Controlador_VGA/Controlador_VGA1/vga_sync.vhd}
vcom -93 -work work {../src/Controlador_VGA/Controlador_VGA1/vga_font_rom.vhd}
vcom -93 -work work {../src/Controlador_VGA/Controlador_VGA1/vga_ram_dual.vhd}
vcom -93 -work work {../src/mem_ctrl/SRAMController.vhd}
vcom -93 -work work {../src/mem_ctrl/MemoryController.vhd}


# Datapath and things inside it
# regfile
vcom -93 -work work {../src/proc/banco_regs/regfile.vhd}
# alu
vcom -93 -work work {../src/proc/alu/alu_arit_log.vhd}
vcom -93 -work work {../src/proc/alu/alu_comp.vhd}
vcom -93 -work work {../src/proc/alu/alu_ext_arit.vhd}
vcom -93 -work work {../src/proc/alu/alu_misc.vhd}
vcom -93 -work work {../src/proc/alu/alu.vhd}
# dp itself
vcom -93 -work work {../src/proc/datapath/datapath.vhd}


# Control Unit and things inside it
vcom -93 -work work {../src/proc/uc/multi.vhd}
vcom -93 -work work {../src/proc/uc/control_l.vhd}
vcom -93 -work work {../src/proc/uc/unidad_control.vhd}
vcom -93 -work work {../src/proc/uc/illegal_ir.vhd}


# Processor
vcom -93 -work work {../src/proc/proc.vhd}


# Associated components in the DUT
vcom -93 -work work {../src/driver7Segmentos.vhd}
vcom -93 -work work {../src/decoder7Segmentos.vhd}
vcom -93 -work work {../src/debugger.vhd}
# TLE for the DUT
vcom -93 -work work {../src/sisa.vhd}


# ========== PURELY FOR SIMULATION ==========
# Memory simulation module and shit
vcom -93 -work work {./async_64Kx16.vhd}
# PS2 keyboard emulator
vcom -93 -work work {./ps2_keyboard_emul.vhd}
# TLE for the testbench
vcom -93 -work work {./test_sisa.vhd}
