# approximate_multiplier
This project implements a **4x4-bit multiplier** using both **exact** and **approximate** arithmetic components in Verilog. The goal is to reduce hardware complexity and power consumption by selectively introducing approximate computing techniques.

The final result is computed using partial product generation followed by a combination of exact and approximate addition using custom-designed half/full adders and compressors.
half_adder:
sum = a ⊕ b
carry = a ⋅ b
a	b	sum	carry
0	0	0	0
0	1	1	0
1	0	1	0
1	1	0	1
