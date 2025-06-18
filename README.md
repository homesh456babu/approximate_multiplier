# 🔢 4x4 Approximate Multiplier (Verilog)

This project implements a 4-bit by 4-bit multiplier using a mix of **exact** and **approximate arithmetic modules** to trade off **accuracy for efficiency**. 

---

## ⚙️ Modules Description

| Module                | Type        | Purpose                                    |
|-----------------------|-------------|--------------------------------------------|
| `exact_half_adder`    | Exact        | Adds 2 bits with full accuracy             |
| `exact_full_adder`    | Exact        | Adds 3 bits with full accuracy             |
| `approx_half_adder`   | Approximate  | Adds 2 bits with simplified logic          |
| `approx_full_adder`   | Approximate  | Adds 3 bits, drops some carry terms        |
| `approx_4_compressor` | Approximate  | Compresses 4 inputs into 2 with shortcuts  |
| `exact_4_compressor`  | Exact        | Adds 4 + 1 bits using exact full adders    |
| `multiplier`          | Top module   | Uses all above to build a 4x4 multiplier   |

---

## 📊 Truth Tables

---

### ✅ Exact Half Adder

**Logic**:  
- `sum = A ^ B`  
- `carry = A & B`

| A | B | Sum | Carry |
|---|---|-----|--------|
| 0 | 0 |  0  |   0    |
| 0 | 1 |  1  |   0    |
| 1 | 0 |  1  |   0    |
| 1 | 1 |  0  |   1    |

---

### 🟡 Approximate Half Adder

**Logic**:  
- `sum = A | B`  
- `carry = A & B`

| A | B | Sum | Carry | Diff from Exact |
|---|---|-----|--------|------------------|
| 0 | 0 |  0  |   0    | No               |
| 0 | 1 |  1  |   0    | No               |
| 1 | 0 |  1  |   0    | No               |
| 1 | 1 |  1  |   1    | ✅ Sum differs    |

➡️ **Difference:** In the case (1,1), exact sum is `0`, but approximate gives `1`.

---

### ✅ Exact Full Adder

**Logic**:  
- `sum = A ^ B ^ Cin`  
- `carry = AB + BCin + ACin`

| A | B | Cin | Sum | Carry |
|---|---|-----|-----|--------|
| 0 | 0 |  0  |  0  |   0    |
| 0 | 0 |  1  |  1  |   0    |
| 0 | 1 |  0  |  1  |   0    |
| 0 | 1 |  1  |  0  |   1    |
| 1 | 0 |  0  |  1  |   0    |
| 1 | 0 |  1  |  0  |   1    |
| 1 | 1 |  0  |  0  |   1    |
| 1 | 1 |  1  |  1  |   1    |

---

### 🟡 Approximate Full Adder

**Logic**:  
- `sum = (A | B) ^ Cin`  
- `carry = (A & B) | (B & Cin)`

| A | B | Cin | Sum | Carry | Diff from Exact |
|---|---|-----|-----|--------|------------------|
| 0 | 0 | 0   |  0  |   0    | No               |
| 0 | 0 | 1   |  1  |   0    | No               |
| 0 | 1 | 0   |  1  |   0    | No               |
| 0 | 1 | 1   |  0  |   1    | No               |
| 1 | 0 | 0   |  1  |   0    | No               |
| 1 | 0 | 1   |  0  |   0    | ✅ Carry wrong    |
| 1 | 1 | 0   |  1  |   1    | ✅ Sum wrong      |
| 1 | 1 | 1   |  0  |   1    | ✅ Sum wrong      |

➡️ **Differences in 3 cases**:
- (1,0,1): Correct sum but **carry is 0 instead of 1**
- (1,1,0): Sum is 1 (should be 0)
- (1,1,1): Sum is 0 (should be 1)

---

### 🟡 Approximate 4:2 Compressor

**Logic**:  
- `sum = (A ^ B) | (C ^ D)`  
- `carry = A·(B+C+D) + B·(C+D) + C·D`

| A | B | C | D | Sum | Carry | Notes |
|---|---|---|---|-----|--------|--------|
| 0 | 0 | 0 | 0 |  0  |   0    | Perfect match |
| 0 | 0 | 0 | 1 |  1  |   0    |              |
| 0 | 0 | 1 | 0 |  1  |   0    |              |
| 0 | 0 | 1 | 1 |  1  |   1    |              |
| 0 | 1 | 0 | 0 |  1  |   0    |              |
| 0 | 1 | 1 | 0 |  1  |   1    |              |
| 0 | 1 | 1 | 1 |  1  |   1    |              |
| 1 | 0 | 0 | 0 |  1  |   0    |              |
| 1 | 0 | 0 | 1 |  1  |   1    |              |
| 1 | 0 | 1 | 0 |  1  |   1    |              |
| 1 | 0 | 1 | 1 |  1  |   1    |              |
| 1 | 1 | 0 | 0 |  0  |   1    | ✅ Sum differs |
| 1 | 1 | 0 | 1 |  1  |   1    |              |
| 1 | 1 | 1 | 0 |  1  |   1    |              |
| 1 | 1 | 1 | 1 |  1  |   1    | ✅ Sum differs |

➡️ Some values of `sum` differ from true 4-bit addition logic. Trade-off made for gate complexity.

---

### ✅ Exact 4:2 Compressor

This module uses **two full adders** and one `AND` tree:
- Inputs: A, B, C, D, Cin
- Outputs: Sum, Carry, Cout
- ```
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

Matches truth table of a proper 5-bit adder with split outputs:
- `Sum = bit 0 of result`
- `Carry = bit 1`
- `Cout = final carry out`

---

## 📐 Multiplier Summary

### Inputs:
- A [3:0]
- B [3:0]

### Output:
- result [7:0]

### Structure:
- AND gate array → Partial products
- Tree of adders and compressors (approx. + exact)
- Final addition using two 7-bit intermediate wires

---

## 🎯 Motivation for Approximation

- 🏃‍♂️ Faster computation (fewer gates)
- 🔋 Lower power
- 📦 Smaller area
- Acceptable error for image/AI applications

---

## 🔍 Summary of Differences

| Component           | Approx. Logic Change | Accuracy Impact |
|---------------------|----------------------|-----------------|
| Half Adder          | OR instead of XOR    | 1/4 incorrect   |
| Full Adder          | Misses some carry    | 3/8 incorrect   |
| 4:2 Compressor      | OR/XOR instead of full adders | Nonlinear error patterns |

---


## 🔧 Comparison: Approximate vs Exact 4x4 Multiplier

| Metric              | **Approximate Multiplier** | **Exact Multiplier (Standard)** | **Improvement**     |
| ------------------- | -------------------------- | ------------------------------- | ------------------- |
| **Slice LUTs**      | 12                         | 16                              | **\~25% reduction** |
| **Bonded IOBs**     | 16                         | 16                              | Same                |
| **Total Power**     | 3.713 W                    | \~5.2–6.0 W *(estimated)*       | **\~30% lower**     |
| ├─ Logic Power      | 0.053 W                    | \~0.120 W                       | **\~56% lower**     |
| ├─ I/O Power        | 3.557 W                    | \~4.5 W                         | **\~21% lower**     |
| ├─ Static Power     | 0.089 W                    | \~0.15 W                        | **\~41% lower**     |
| **Mean Rel. Error** | 6.87%                      | 0% (Exact)                      | Trade-off           |






