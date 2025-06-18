# approximate_multiplier_4×4
in this we are going to go through some prerequisites to understand how approximate adders work and how can these be implemented into approximate multipliers.

# exact_multiplier
this project assumes that you have basic knowledge of Digital Logic design regarding logic gates and bits. if not you can follow the link to know about em
https://r.mtdv.me/watch?v=JNJfJvkCUF

## half_adder:
- **sum** = a ⊕ b
- **carry** = a ⋅ b

| a | b | sum | carry |
|---|---|-----|-------|
| 0 | 0 | 0   | 0     |
| 0 | 1 | 1   | 0     |
| 1 | 0 | 1   | 0     |
| 1 | 1 | 0   | 1     |

## full_adder:
- **sum** = a ⊕ b ⊕ cin
- **carry** = (a ⋅ b) + (b ⋅ cin) + (cin ⋅ a)

| a | b | cin | sum | cout |
|---|---|-----|-----|------|
| 0 | 0 |  0  |  0  |  0   |
| 0 | 0 |  1  |  1  |  0   |
| 0 | 1 |  0  |  1  |  0   |
| 0 | 1 |  1  |  0  |  1   |
| 1 | 0 |  0  |  1  |  0   |
| 1 | 0 |  1  |  0  |  1   |
| 1 | 1 |  0  |  0  |  1   |
| 1 | 1 |  1  |  1  |  1   |

## compressor:

an **compressor** is a combinational circuit that compresses multiple binary inputs into fewer outputs while preserving their arithmetic sum. this is commonly used in digital circuits for applications such as arithmetic operations.

---
### here's how it's done
if we need to find compressor for **n-input** bits. First we need to know no. of bits required to represent the output (yes it is the sum) and may also contain carry bits denpending upon width of the output:

<code style="color : name_color">No. of Bits = ⌈ log₂(n + 1) ⌉</code>

#### **design using full_adders and half_adders:**

1. **group bits:**  
   - combine three bits at a time using a **full_adder (fa)**.
   - continue combining the carry and sum outputs until the minimal number of output bits is achieved.

2. **use half_adders or more full_adders:**  
   - add any remaining bits from partial sums and carry bits.

---

example: 4:2 compressor (4 inputs, 2 outputs)

| **inputs (a,b,c,d)** | **sum output** | **carry output** |
|----------------------|----------------|------------------|
| 0000                 | 0              | 0                |
| 0001                 | 1              | 0                |
| 0011                 | 0              | 1                |
| 1111                 | 0              | 2                |

### **circuit design for 4:2 compressor**
- **step 1:** Use a **full_adder (fa)** to combine `a`, `b`, and `c`.
- **step 2:** Use a second **full_adder (fa)** to take the sum from the first and `d`.

---

# approximate_multiplier
till now we have seen how to make an exact multiplier now coming to real part how to make an approximate version.

## approximate_half_adder:
- **sum** = a + b
- **carry** = a ⋅ b
weel we can think that what does it change but XOR gates are slightly more complex in terms of transistor count compared to OR gates.

<table> <thead> <tr> <th colspan="2">Inputs</th> <th colspan="2">Exact</th> <th colspan="2">Approximate</th> </tr> <tr> <th>a</th> <th>b</th> <th>sum</th> <th>carry</th> <th>sum</th> <th>carry</th> </tr> </thead> <tbody> <tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr> <tr><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td><td>0</td></tr> <tr><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td></tr> <tr><td>1</td><td>1</td><td>0</td><td>1</td><td>1</td><td>1</td></tr> </tbody> </table>

## full_adder:
- **sum** = a + b + cin
- **carry** = (a ⋅ b) + (b ⋅ cin)

<table> <thead> <tr> <th colspan="3">Inputs</th> <th colspan="2">Exact</th> <th colspan="2">Approximate</th> </tr> <tr> <th>a</th> <th>b</th> <th>cin</th> <th>sum</th> <th>carry</th> <th>sum</th> <th>carry</th> </tr> </thead> <tbody> <tr><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr> <tr><td>0</td><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td><td>0</td></tr> <tr><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td></tr> <tr><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td><td>1</td><td>1</td></tr> <tr><td>1</td><td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td></tr> <tr><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td>1</td><td>0</td></tr> <tr><td>1</td><td>1</td><td>0</td><td>0</td><td>1</td><td>1</td><td>1</td></tr> <tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr> </tbody> </table>

## compressor:
We will make this approximate compressor just by combining two approximate full adders.      
```
       A      B      C
       │      │      │
   ┌───▼──────▼──────▼───┐
   │  Approximate Full   │-- ► Cout
   │       Adder         │
   └───┬─────────────────┘
       │               
       |               
       │               
       │             D
       │             │
   ┌───▼─────────────▼──┐
   │  Approximate Full  │
   │       Adder        │
   └───┬─────────────┬──┘
       │             │
       ▼             ▼
     Carry          Sum
```
<table> <thead> <tr> <th rowspan="2">A</th> <th rowspan="2">B</th> <th rowspan="2">C</th> <th rowspan="2">D</th> <th colspan="2">Exact</th> <th colspan="2">Approximate</th> </tr> <tr> <th>Sum</th> <th>Carry</th> <th>Sum</th> <th>Carry</th> </tr> </thead> <tbody> <tr> <td>0</td> <td>0</td> <td>0</td> <td>0</td> <td>0</td> <td>0</td> <td>0</td> <td>0</td> </tr> <tr> <td>0</td> <td>0</td> <td>0</td> <td>1</td> <td>1</td> <td>0</td> <td>1</td> <td>0</td> </tr> <tr> <td>0</td> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>0</td> </tr> <tr> <td>0</td> <td>0</td> <td>1</td> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> </tr> <tr> <td>0</td> <td>1</td> <td>0</td> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>0</td> </tr> <tr> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> </tr> <tr> <td>0</td> <td>1</td> <td>1</td> <td>0</td> <td>0</td> <td>1</td> <td>1</td> <td>0</td> </tr> <tr> <td>0</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> </tr> <tr> <td>1</td> <td>0</td> <td>0</td> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>0</td> </tr> <tr> <td>1</td> <td>0</td> <td>0</td> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> </tr> <tr> <td>1</td> <td>0</td> <td>1</td> <td>0</td> <td>0</td> <td>1</td> <td>1</td> <td>0</td> </tr> <tr> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> </tr> <tr> <td>1</td> <td>1</td> <td>0</td> <td>0</td> <td>0</td> <td>1</td> <td>1</td> <td>0</td> </tr> <tr> <td>1</td> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>1</td> </tr> <tr> <td>1</td> <td>1</td> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> <td>0</td> </tr> <tr> <td>1</td> <td>1</td> <td>1</td> <td>1</td> <td>0</td> <td>1</td> <td>1</td> <td>1</td> </tr> </tbody> </table>

## partial_product_transformation:
the approximation involves the transformation of partial product terms a<sub>m,n</sub> and a<sub>n,m</sub> ( a<sub>m,n</sub> = a[m] $\times$ b[n] ) into propagate and generate terms:
- p<sub>m,n</sub> = a<sub>m,n</sub> $+$ a<sub>n,m</sub>
- g<sub>m,n</sub> = a<sub>m,n</sub> $\cdot$ a<sub>n,m</sub>
- a<sub>m,m</sub> terms are retained.

the generate signal g<sub>m,n</sub> has the probability of being 1/16, which is less than the probability of p<sub>m,n</sub>. this is significantly lower than 1/4, the probability of a<sub>m,n</sub>. the probability of the altered partial product p<sub>m,n</sub> being one is 1/16 + 3/16 + 3/16 = 7/16, which is higher than g<sub>m,n</sub>.
### why all this ?
observe the truth table of approximate compressor we are using the errors occure when we have c or d as 1, when we replace partial products with propagate and generate terms we are making the first two number which we going to use as a and b to be more probable to become 1 and decrese that of the last two c and d hence getting a better approximation.

## you can see the order of using approximate compressors and adders in the verilog implementation.
---




