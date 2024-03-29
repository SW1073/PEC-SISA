set ENTITIES(0) "sim:/test_sisa/SoC/*"
set ENTITIES(1) "sim:/test_sisa/SoC/proc0/*"
set ENTITIES(2) "sim:/test_sisa/SoC/memctrl0/*"

set GROUPS(0) "SoC"
set GROUPS(1) "proc"
set GROUPS(2) "Memory Controller"

add wave -label CLOCK_6_25 -radix bin sim:/test_sisa/SoC/proc0/clk
add wave -label CLOCK_50   -radix bin sim:/test_sisa/SoC/CLOCK_50

for {set i 0} {$i < [array size ENTITIES]} {incr i} {
    add wave -group $GROUPS($i) -divider "IN"
    add wave -group $GROUPS($i) -radix hex -in       $ENTITIES($i)
    add wave -group $GROUPS($i) -divider "OUT"
    add wave -group $GROUPS($i) -radix hex -out      $ENTITIES($i)
    # add wave -group $GROUPS($i) -divider "INOUT"
    # add wave -group $GROUPS($i) -radix hex -inout    $ENTITIES($i)
    add wave -group $GROUPS($i) -divider "INTERNAL"
    add wave -group $GROUPS($i) -radix hex -internal $ENTITIES($i)
}

for {set i 50} {$i >= 0} {incr i -1} {
    add wave -group "Memory Contents" -label "word $i" -radix hex sim:/test_sisa/mem0/mem_array($i)
}

configure wave -signalnamewidth 1
configure wave -timelineunits ns
