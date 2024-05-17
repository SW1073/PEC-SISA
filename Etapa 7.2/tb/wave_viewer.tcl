set dataset "sim1:/"

array set VAR1 {
    "SoC" "test_sisa/SoC/*"
    "proc" "test_sisa/SoC/proc0/*"

    "datapath" "test_sisa/SoC/proc0/dp/*"
    "ALU" "test_sisa/SoC/proc0/dp/al/*"
    "Regfile" "test_sisa/SoC/proc0/dp/reg/*"

    "Unidad Control" "test_sisa/SoC/proc0/uc/*"
    "Control Logic" "test_sisa/SoC/proc0/uc/control_l0/*"
    "Multi" "test_sisa/SoC/proc0/uc/multi0/*"
    "Illegal IR" "test_sisa/SoC/proc0/uc/ex_ctrl/illegal_ir1/*"
    "Exception Controller" "test_sisa/SoC/proc0/uc/ex_ctrl/*"

    "Memory Controller" "test_sisa/SoC/memctrl0/*"
    "Sram Controller" "test_sisa/SoC/memctrl0/sramctrl0/*"
    "VGA Controller" "test_sisa/SoC/vgactrl0/*"
    "VGA ROM" "test_sisa/SoC/vgactrl0/u_font_rom/*"
    "VGA_RAM" "test_sisa/SoC/vgactrl0/U_MonitorRam/*"

    "IO Controller" "test_sisa/SoC/io/*"
    "PS2 Keyboard" "test_sisa/keyboard/*"
}

add wave -label CLOCK_6_25 -radix bin "${dataset}test_sisa/SoC/proc0/clk"
add wave -label CLOCK_50   -radix bin "${dataset}test_sisa/SoC/CLOCK_50"

foreach name [array name VAR1] {
    add wave -group $dataset$name -divider "IN/OUT/INOUT"
    add wave -group $dataset$name -radix hex -in -out -inout $VAR1($name)
    add wave -group $dataset$name -divider "INTERNAL"
    add wave -group $dataset$name -radix hex -internal $VAR1($name)
}

for {set i 50} {$i >= 0} {incr i -1} {
    add wave -group "Memory Contents" -label "word $i" -radix hex "${dataset}test_sisa/mem0/mem_array(${i})"
}

for {set i 200} {$i >= 100} {incr i -1} {
    add wave -group "LO VGA RAM Contents" -label "lo byte $i" -radix hex "${dataset}test_sisa/SoC/vgactrl0/U_MonitorRam/mem0(${i})"
}

for {set i 200} {$i >= 100} {incr i -1} {
    add wave -group "HI VGA RAM Contents" -label "hi byte $i" -radix hex "${dataset}test_sisa/SoC/vgactrl0/U_MonitorRam/mem1(${i})"
}

configure wave -signalnamewidth 1
configure wave -timelineunits ns
