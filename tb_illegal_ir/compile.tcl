# Compile packages, and things that do not generate any dependency
vcom -93 -work work {src/pkg/package_control.vhd}
vcom -93 -work work {src/pkg/package_opcodes.vhd}
vcom -93 -work work {src/pkg/package_alu.vhd}

# TLE for the DUT
vcom -93 -work work {src/illegal_ir.vhd}

# ========== PURELY FOR SIMULATION ==========
# TLE for the testbench
vcom -93 -work work {tb/test_illegal_ir.vhd}
