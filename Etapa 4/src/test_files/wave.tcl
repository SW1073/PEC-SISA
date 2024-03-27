add wave -divider CLOCKS
add wave -label CLOCK_6_25 -radix bin sim:/test_sisa/SoC/proc0/clk
add wave -label CLOCK_50   -radix bin sim:/test_sisa/SoC/CLOCK_50

add wave -divider SoC
add wave -label SRAM_ADDR			-radix hex	sim:/test_sisa/SoC/SRAM_ADDR
add wave -label SRAM_DQ				-radix hex	sim:/test_sisa/SoC/SRAM_DQ
add wave -label SRAM_UPPER_BYTE					sim:/test_sisa/SoC/SRAM_UB_N
add wave -label SRAM_LOWER_BYTE					sim:/test_sisa/SoC/SRAM_LB_N
add wave -label SRAM_CHIP_ENABLE				sim:/test_sisa/SoC/SRAM_CE_N
add wave -label SRAM_OE							sim:/test_sisa/SoC/SRAM_OE_N
add wave -label SRAM_WRITE_ENABLE				sim:/test_sisa/SoC/SRAM_WE_N
add wave -label BOOT							sim:/test_sisa/SoC/SW
add wave -label proc/word_byte					sim:/test_sisa/SoC/s_word_byte
add wave -label proc/we							sim:/test_sisa/SoC/s_wr_m
add wave -label proc/mem_address	-radix hex	sim:/test_sisa/SoC/s_addr_m
add wave -label proc/data_to_mem	-radix hex	sim:/test_sisa/SoC/s_data_wr
add wave -label proc/data_from_mem	-radix hex	sim:/test_sisa/SoC/s_rd_data

add wave -divider ALU

# add wave -divider MemoryController
# add wave -radix hex sim:/test_sisa/SoC/memctrl0/addr
# add wave -radix hex sim:/test_sisa/SoC/memctrl0/wr_data
# add wave -radix hex sim:/test_sisa/SoC/memctrl0/rd_data
# add wave  sim:/test_sisa/SoC/memctrl0/we
# add wave  sim:/test_sisa/SoC/memctrl0/byte_m
# add wave -radix hex sim:/test_sisa/SoC/memctrl0/SRAM_ADDR
# add wave -radix hex sim:/test_sisa/SoC/memctrl0/SRAM_DQ
# add wave  sim:/test_sisa/SoC/memctrl0/SRAM_UB_N
# add wave  sim:/test_sisa/SoC/memctrl0/SRAM_LB_N
# add wave  sim:/test_sisa/SoC/memctrl0/SRAM_CE_N
# add wave  sim:/test_sisa/SoC/memctrl0/SRAM_OE_N
# add wave  sim:/test_sisa/SoC/memctrl0/SRAM_WE_N
# add wave -radix hex sim:/test_sisa/SoC/memctrl0/s_sram_data_readed
# add wave  sim:/test_sisa/SoC/memctrl0/s_sram_wr

add wave -divider Memory\ Values
add wave -label word\ 60 -radix hex sim:/test_sisa/mem0/mem_array(60)
add wave -label word\ 59 -radix hex sim:/test_sisa/mem0/mem_array(59)
add wave -label word\ 58 -radix hex sim:/test_sisa/mem0/mem_array(58)
add wave -label word\ 57 -radix hex sim:/test_sisa/mem0/mem_array(57)
add wave -label word\ 56 -radix hex sim:/test_sisa/mem0/mem_array(56)
add wave -label word\ 55 -radix hex sim:/test_sisa/mem0/mem_array(55)
add wave -label word\ 54 -radix hex sim:/test_sisa/mem0/mem_array(54)
add wave -label word\ 53 -radix hex sim:/test_sisa/mem0/mem_array(53)
add wave -label word\ 52 -radix hex sim:/test_sisa/mem0/mem_array(52)
add wave -label word\ 51 -radix hex sim:/test_sisa/mem0/mem_array(51)
add wave -label word\ 50 -radix hex sim:/test_sisa/mem0/mem_array(50)
add wave -label word\ 49 -radix hex sim:/test_sisa/mem0/mem_array(49)
add wave -label word\ 48 -radix hex sim:/test_sisa/mem0/mem_array(48)
add wave -label word\ 47 -radix hex sim:/test_sisa/mem0/mem_array(47)
add wave -label word\ 46 -radix hex sim:/test_sisa/mem0/mem_array(46)
add wave -label word\ 45 -radix hex sim:/test_sisa/mem0/mem_array(45)
add wave -label word\ 44 -radix hex sim:/test_sisa/mem0/mem_array(44)
add wave -label word\ 43 -radix hex sim:/test_sisa/mem0/mem_array(43)
add wave -label word\ 42 -radix hex sim:/test_sisa/mem0/mem_array(42)
add wave -label word\ 41 -radix hex sim:/test_sisa/mem0/mem_array(41)
add wave -label word\ 40 -radix hex sim:/test_sisa/mem0/mem_array(40)
add wave -label word\ 39 -radix hex sim:/test_sisa/mem0/mem_array(39)
add wave -label word\ 38 -radix hex sim:/test_sisa/mem0/mem_array(38)
add wave -label word\ 37 -radix hex sim:/test_sisa/mem0/mem_array(37)
add wave -label word\ 36 -radix hex sim:/test_sisa/mem0/mem_array(36)
add wave -label word\ 35 -radix hex sim:/test_sisa/mem0/mem_array(35)
add wave -label word\ 34 -radix hex sim:/test_sisa/mem0/mem_array(34)
add wave -label word\ 33 -radix hex sim:/test_sisa/mem0/mem_array(33)
add wave -label word\ 32 -radix hex sim:/test_sisa/mem0/mem_array(32)
add wave -label word\ 31 -radix hex sim:/test_sisa/mem0/mem_array(31)
add wave -label word\ 30 -radix hex sim:/test_sisa/mem0/mem_array(30)
add wave -label word\ 29 -radix hex sim:/test_sisa/mem0/mem_array(29)
add wave -label word\ 28 -radix hex sim:/test_sisa/mem0/mem_array(28)
add wave -label word\ 27 -radix hex sim:/test_sisa/mem0/mem_array(27)
add wave -label word\ 26 -radix hex sim:/test_sisa/mem0/mem_array(26)
add wave -label word\ 25 -radix hex sim:/test_sisa/mem0/mem_array(25)
add wave -label word\ 24 -radix hex sim:/test_sisa/mem0/mem_array(24)
add wave -label word\ 23 -radix hex sim:/test_sisa/mem0/mem_array(23)
add wave -label word\ 22 -radix hex sim:/test_sisa/mem0/mem_array(22)
add wave -label word\ 21 -radix hex sim:/test_sisa/mem0/mem_array(21)
add wave -label word\ 20 -radix hex sim:/test_sisa/mem0/mem_array(20)
add wave -label word\ 19 -radix hex sim:/test_sisa/mem0/mem_array(19)
add wave -label word\ 18 -radix hex sim:/test_sisa/mem0/mem_array(18)
add wave -label word\ 17 -radix hex sim:/test_sisa/mem0/mem_array(17)
add wave -label word\ 16 -radix hex sim:/test_sisa/mem0/mem_array(16)
add wave -label word\ 15 -radix hex sim:/test_sisa/mem0/mem_array(15)
add wave -label word\ 14 -radix hex sim:/test_sisa/mem0/mem_array(14)
add wave -label word\ 13 -radix hex sim:/test_sisa/mem0/mem_array(13)
add wave -label word\ 12 -radix hex sim:/test_sisa/mem0/mem_array(12)
add wave -label word\ 11 -radix hex sim:/test_sisa/mem0/mem_array(11)
add wave -label word\ 10 -radix hex sim:/test_sisa/mem0/mem_array(10)
add wave -label word\ 9 -radix hex sim:/test_sisa/mem0/mem_array(9)
add wave -label word\ 8 -radix hex sim:/test_sisa/mem0/mem_array(8)
add wave -label word\ 7 -radix hex sim:/test_sisa/mem0/mem_array(7)
add wave -label word\ 6 -radix hex sim:/test_sisa/mem0/mem_array(6)
add wave -label word\ 5 -radix hex sim:/test_sisa/mem0/mem_array(5)
add wave -label word\ 4 -radix hex sim:/test_sisa/mem0/mem_array(4)
add wave -label word\ 3 -radix hex sim:/test_sisa/mem0/mem_array(3)
add wave -label word\ 2 -radix hex sim:/test_sisa/mem0/mem_array(2)
add wave -label word\ 1 -radix hex sim:/test_sisa/mem0/mem_array(1)
add wave -label word\ 0 -radix hex sim:/test_sisa/mem0/mem_array(0)
