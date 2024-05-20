array set VAR1 {
    "SoC" "sim:/test_sisa/SoC/*"
    "proc" "sim:/test_sisa/SoC/proc0/*"

    "datapath" "sim:/test_sisa/SoC/proc0/dp/*"
    "ALU" "sim:/test_sisa/SoC/proc0/dp/al/*"
    "Regfile" "sim:/test_sisa/SoC/proc0/dp/reg/*"

    "Unidad Control" "sim:/test_sisa/SoC/proc0/uc/*"
    "Control Logic" "sim:/test_sisa/SoC/proc0/uc/control_l0/*"
    "Multi" "sim:/test_sisa/SoC/proc0/uc/multi0/*"

    "Memory Controller" "sim:/test_sisa/SoC/memctrl0/*"
    "Sram Controller" "sim:/test_sisa/SoC/memctrl0/sramctrl0/*"
    "VGA Controller" "sim:/test_sisa/SoC/vgactrl0/*"
    "VGA ROM" "sim:/test_sisa/SoC/vgactrl0/u_font_rom/*"
    "VGA_RAM" "sim:/test_sisa/SoC/vgactrl0/U_MonitorRam/*"

    "INTR Controller" "test_sisa/SoC/io/intr_ctrl/*"
    "Keyboard INTR Controller" "test_sisa/SoC/io/keyboard0/*"
    "Switches INTR Controller" "test_sisa/SoC/io/switches0/*"
    "Keys INTR Controller" "test_sisa/SoC/io/keys0/*"
    "Timer INTR Controller" "test_sisa/SoC/io/timer0/*"

    "IO Controller" "sim:/test_sisa/SoC/io/*"
    "PS2 Keyboard" "sim:/test_sisa/keyboard/*"
}

add wave -label CLOCK_6_25 -radix bin sim:/test_sisa/SoC/proc0/clk
add wave -label CLOCK_50   -radix bin sim:/test_sisa/SoC/CLOCK_50

foreach name [array name VAR1] {
    add wave -group $name -divider "IN/OUT/INOUT"
    add wave -group $name -radix hex -in -out -inout $VAR1($name)
    add wave -group $name -divider "INTERNAL"
    add wave -group $name -radix hex -internal $VAR1($name)
}

# for {set i 200} {$i >= 100} {incr i -1} {
#     add wave -group "Memory Contents" -label "word $i" -radix hex sim:/test_sisa/mem0/mem_array($i)
# }

for {set i 200} {$i >= 100} {incr i -1} {
    add wave -group "LO VGA RAM Contents" -label "lo byte $i" -radix hex sim:/test_sisa/SoC/vgactrl0/U_MonitorRam/mem0($i)
}

for {set i 200} {$i >= 100} {incr i -1} {
    add wave -group "HI VGA RAM Contents" -label "hi byte $i" -radix hex sim:/test_sisa/SoC/vgactrl0/U_MonitorRam/mem1($i)
}

configure wave -signalnamewidth 1
configure wave -timelineunits ns
