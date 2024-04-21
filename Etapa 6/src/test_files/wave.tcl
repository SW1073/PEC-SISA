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

    "IO Controller" "sim:/test_sisa/SoC/io/*"
}

add wave -label CLOCK_6_25 -radix bin sim:/test_sisa/SoC/proc0/clk
add wave -label CLOCK_50   -radix bin sim:/test_sisa/SoC/CLOCK_50

foreach name [array name VAR1] {
    add wave -group $name -divider "IN/OUT/INOUT"
    add wave -group $name -radix hex -in -out -inout $VAR1($name)
    add wave -group $name -divider "INTERNAL"
    add wave -group $name -radix hex -internal $VAR1($name)
}

for {set i 50} {$i >= 0} {incr i -1} {
    add wave -group "Memory Contents" -label "word $i" -radix hex sim:/test_sisa/mem0/mem_array($i)
}

configure wave -signalnamewidth 1
configure wave -timelineunits ns
