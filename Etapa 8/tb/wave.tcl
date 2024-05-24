set dataset "sim:/"

array set VAR1 {
    "SoC" "test_sisa/SoC/*"
    "proc" "test_sisa/SoC/proc0/*"

    "datapath" "test_sisa/SoC/proc0/dp/*"
    "ALU" "test_sisa/SoC/proc0/dp/al/*"
    "Regfile" "test_sisa/SoC/proc0/dp/reg/*"
    "TLB_INSTR" "test_sisa/SoC/proc0/dp/tlbi/*"
    "TLB_DATA" "test_sisa/SoC/proc0/dp/tlbd/*"

    "Unidad Control" "test_sisa/SoC/proc0/uc/*"
    "Control Logic" "test_sisa/SoC/proc0/uc/control_l0/*"
    "Multi" "test_sisa/SoC/proc0/uc/multi0/*"
    "Illegal IR" "test_sisa/SoC/proc0/uc/control_l0/illegal_ir0/*"
    "Exception Controller" "test_sisa/SoC/proc0/uc/ex_ctrl/*"

    "Memory Controller" "test_sisa/SoC/memctrl0/*"
    "Sram Controller" "test_sisa/SoC/memctrl0/sramctrl0/*"
    "VGA Controller" "test_sisa/SoC/vgactrl0/*"
    "VGA ROM" "test_sisa/SoC/vgactrl0/u_font_rom/*"
    "VGA_RAM" "test_sisa/SoC/vgactrl0/U_MonitorRam/*"

    "INTR Controller" "test_sisa/SoC/io/intr_ctrl/*"
    "Keyboard INTR Controller" "test_sisa/SoC/io/keyboard0/*"
    "Switches INTR Controller" "test_sisa/SoC/io/switches0/*"
    "Keys INTR Controller" "test_sisa/SoC/io/keys0/*"
    "Timer INTR Controller" "test_sisa/SoC/io/timer0/*"

    "IO Controller" "test_sisa/SoC/io/*"
    "PS2 Keyboard" "test_sisa/keyboard/*"
}

add wave -label CLOCK_6_25 -radix bin "${dataset}test_sisa/SoC/proc0/clk"
add wave -label CLOCK_50   -radix bin "${dataset}test_sisa/SoC/CLOCK_50"

foreach name [array name VAR1] {
    add wave -group $name -divider "IN/OUT/INOUT"
    add wave -group $name -radix hex -in -out -inout $dataset$VAR1($name)
    add wave -group $name -divider "INTERNAL"
    add wave -group $name -radix hex -internal $dataset$VAR1($name)
}

for {set i 50} {$i >= 0} {incr i -1} {
    add wave -group "Memory Contents" -label "word $i" -radix hex "${dataset}test_sisa/mem0/mem_array(${i})"
}

#for {set i 100} {$i >= 0} {incr i -1} {
#    add wave -group "LO VGA RAM Contents" -label "lo byte $i" -radix hex "${dataset}test_sisa/SoC/vgactrl0/U_MonitorRam/mem0(${i})"
#}
#
#for {set i 100} {$i >= 0} {incr i -1} {
#    add wave -group "HI VGA RAM Contents" -label "hi byte $i" -radix hex "${dataset}test_sisa/SoC/vgactrl0/U_MonitorRam/mem1(${i})"
#}

configure wave -signalnamewidth 1
configure wave -timelineunits ns
