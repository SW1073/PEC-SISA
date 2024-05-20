array set VAR1 {
    "DUT" "sim:/test_illegal_ir/dut/*"
}

add wave -label clk -radix bin "sim:/test_illegal_ir/clk"

foreach name [array name VAR1] {
    add wave -group $name -divider "IN/OUT/INOUT"
    add wave -group $name -radix hex -in -out -inout $VAR1($name)
    add wave -group $name -divider "INTERNAL"
    add wave -group $name -radix hex -internal $VAR1($name)
}

configure wave -signalnamewidth 1
configure wave -timelineunits ns
