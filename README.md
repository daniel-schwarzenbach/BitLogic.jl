# BitLogic

The BitLogic module provides a custom `Bit` type and implements standard logical operators for bitwise operations.

It allows for logical operations using a `Bit` type, which is a subtype of `Integer` and can represent boolean values as `O` and `I`.

# Features

- **Bit Type**: A custom type `Bit` that can be initialized with `0`, `1`, or `Bool` values (`true` or `false`).
- **Logical Operators**: Implements standard logical operators such as `¬` (Not), `∧` (And), `∨` (Or), `↑` (Nand), `↓` (Nor), `⊕` (Xor), `→` (Right Implication), `←` (Left Implication), and `↔` (Equivalence).
- **Truth Table Generation**: A function `truth_table` that generates and prints a truth table for a given logical function.
- **Function Equivalence**: A function `≣` that checks if two logical functions produce the same output for all possible inputs.

# Usage

- Initialize `Bit` values:
  ```julia
  a = I
  b::Bit = 1
  d::Bit = true
  Byte::DataType = NTuple{8,Bit}
  _7_::Byte = (O,O,O,O,O,I,I,I)
  ```
- Perform logical operations:
```julia
a ∧ b  # And operation
a ∨ b  # Or operation
¬a     # Not operation
```
- Generate a truth table for a logical function:
```julia
f(a, b) = a → ¬b
println(truth_table(f))
```
output:
```
f(0, 0) = 1
f(1, 0) = 1
f(0, 1) = 1
f(1, 1) = 0
```
- Check equivalence of two functions:
```julia
f1(a, b) = a ∧ b
f2(a, b) = b ∧ a
f1 ≣ f2  # true
```
saddly the `≡` is already in use in Julia, but one can just overload it manually if one wishes:
```julia
≡ = ≣
f1 ≡ f2 # true
```
This module is useful for applications requiring custom logical 
    operations and truth table analysis.
