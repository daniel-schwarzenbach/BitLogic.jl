
module BitLogic

"""
```
Bit <: Integer
```
Bit = {0,1}  ⟺  Bool = {false,true}

Standard logical operators `¬, ∧, ∨, ↑, ↓, ⊕, →, ←, ↔` are defined.

initialization:
```
a = Bit(0)
b::Bit = 1
c::Bit = 2 # will raise an error!!
d::Bit = true
```
operators:
```
a::Bit = 0
b::Bit = 1
¬a     # Not ; ¬         ; = 1
a ∧ b  # And ; \\wedge    ; = 0
a ∨ b  # Or  ; \\vee      ; = 1
a ↑ b  # Nand; |         ; = 1
a ↓ b  # Nor ; \\downarrow; = 0
a ⊕ b  # Xor ; \\oplus    ; = 1
a → b  # RightImplication; \\rightarrow     ; = 1
a ← b  # LeftImplication;  \\leftarrow      ; = 0  
a ↔ b  # Eqivalence;       \\leftrightarrow ; = 0
```
usage:
is usable as Bool replacement
```
if a.set; while a.set;
```
Implementation:
"""
struct Bit <: Integer
    set::Bool 
    # Constructor
    function Bit(value::Integer)
        if value != 0 && value != 1 
            throw(InexactError(:Bit, Integer, value))
        end
        new(Bool(value))
    end
    Bit(value::Bool) = new(value)
end
export Bit

function Base.show(io::IO, b::Bit)
    print(io, Int(b.set))
end

Base.convert(::Type{Bool}, b::Bit) = b.set
Base.convert(::Type{Bit}, a::Integer) = Bit(a)
Base.Bool(b::Bit) = b.set

#import Base.:¬, :∧, :∨, :↓, :↑, :⊕, :←, :→, :↔ # do not redefine
"Not"
function ¬(a::Bit)
    return Bit(~a.set)
end
export ¬

"And"
function ∧(a::Bit, b::Bit) ::Bit
    return Bit(a.set & b.set)
end
export ∧

"Or"
function ∨(a::Bit, b::Bit) ::Bit
    return Bit(a.set | b.set)
end
export ∨

"Nor"
function ↓(a::Bit, b::Bit) ::Bit
    return Bit(a.set ⊽ b.set)
end
export ↓

"Nand"
function ↑(a::Bit, b::Bit) ::Bit
    return Bit(a.set ⊼ b.set)
end
export ↑

"Xor"
function ⊕(a::Bit, b::Bit) ::Bit
    return Bit(a.set ⊻ b.set)
end
export ⊕

"RightImplycation"
function →(a::Bit, b::Bit) ::Bit
    return ¬a ∨ b
end
export →

"LeftImpication"
function ←(a::Bit, b::Bit) ::Bit
    return a ∨ ¬b
end
export ←

"Equivalence"
function ↔(a::Bit, b::Bit) ::Bit
    return (¬a ∧ ¬b) ∨ (a ∧ b)
end
export ↔

"""
```
truth_table(fn::Function{Bit^n -> Any}) -> String
```

Prints a truth table for a given logical function `fn`.

The function `fn` must accept a tuple of `Bit`s as input.
The truth table stores the output of `fn` for all possible 
    combinations of input bits as a string.

# Arguments
- `fn::Function`: The logical function to evaluate.  It must have the 
signature `Bit^n -> Any`

# Example
```
julia> f(a,b) = a → ¬b; print(truth_table(f))
```
output:
```
f(0, 0) = 0
f(1, 0) = 1
f(0, 1) = 1
f(1, 1) = 1
```
"""
function truth_table(fn::Function) ::String
    n = length(first(methods(fn)).sig.parameters) - 1
    # Generate all combinations of true/false for `n` arguments
    combinations = Iterators.product(fill((Bit(0), Bit(1)), n)...)
    # Initialize an empty string to accumulate results
    result_string = ""
    # Evaluate the function for each combination and append it to the result string
    for inputs in combinations
        result = fn(inputs...)
        result_string *= "$fn($(join(inputs, ", "))) = $result\n"
    end

    # Return the accumulated result string
    return result_string
end
export truth_table


"""
```
≡: ((Bit^n -> Any),(Bit^m -> Any)) -> Bool
(f1,f2) ↦ f1 ≡ f2
```
retruns true only if for all inputs f1 and f2 you get the same output
"""
function ≡(f1::Function, f2::Function) ::Bool
     # Get the number of arguments for the first method of each function
     n = length(first(methods(f1)).sig.parameters) - 1
     n2 = length(first(methods(f2)).sig.parameters) - 1
 
     # Check if the number of arguments is the same
     if n != n2
         return false
     end
    # Generate all combinations of true/false for `n` arguments
    combinations = Iterators.product(fill((Bit(0), Bit(1)), n)...)
    for inputs in combinations
        if f1(inputs...) != f2(inputs...)
            return false
        end
    end
    return true
end


end
