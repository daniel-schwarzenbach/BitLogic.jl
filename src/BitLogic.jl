module BitLogic


export Bit, ¬, ∧, ∨, ↑, ↓, ⊕, →, ←, ↔, truth_table, ≣, 𝟏, 𝟎
"""
```
    struct Bit <: Integer
    Bit(value::Integer)
    Bit(value::Bool)
```
Bit = {𝟎,𝟏}  ⟺  Bool = {false,true}

Standard logical operators `¬, ∧, ∨, ↑, ↓, ⊕, →, ←, ↔` are defined.

initialization:
```
a = Bit(0)
b::Bit = 1
c::Bit = 2 # will raise an error!!
d::Bit = true
e = 𝟏 #\bfone
f = 𝟎 #\bfzero
```
operators:
```
a::Bit = 𝟎
b::Bit = 𝟏
¬a     # Not ; ¬         ; = 𝟏
a ∧ b  # And ; \\wedge    ; = 𝟎
a ∨ b  # Or  ; \\vee      ; = 𝟏
a ↑ b  # Nand; |         ; = 𝟏
a ↓ b  # Nor ; \\downarrow; = 𝟎
a ⊕ b  # Xor ; \\oplus    ; = 𝟏
a → b  # RightImplication; \\rightarrow     ; = 𝟏
a ← b  # LeftImplication;  \\leftarrow      ; = 𝟎
a ↔ b  # Eqivalence;       \\leftrightarrow ; = 𝟎
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
    s = "𝟎"
    if (b.set); s = "𝟏"; end
    print(io, s)
end

Base.convert(::Type{Bool}, b::Bit) = b.set
Base.convert(::Type{Bit}, a::Integer) = Bit(a)
Base.Bool(b::Bit) = b.set

function Base.convert(::Type{Vector{Bit}}, intN::IntN) where IntN <: Integer
    N = sizeof(IntN)*8
    bitVec::Vector{Bit} = zeros(Bit,(N))
    for i ∈ 0:(N-1)
        bitVec[N-i] = (((1 << i) & intN) != 0)
    end
    return bitVec
end

function Base.convert(::Type{IntN}, bitVec::Vector{Bit}) where IntN <: Integer
    N = length(bitVec)
    if sizeof(IntN)*8 < N; throw(InexactError(Integer,"Can't fit whole Vector{Bit} inside")); end
    intN::IntN = 0
    for i ∈ 0:(N-1)
        if (bitVec[N-i].set)
            # flip ith bit
            intN = intN ⊻ (1 << i)
        end
    end
    return intN
end

Base.Vector{Bit}(intN::Integer) = convert(Vector{Bit},intN)
Base.Integer(bitVec::Vector{Bit}) = convert(Integer, bitVec) 


const global 𝟏::Bit = 1
const global 𝟎::Bit = 0

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
f(O, O) = I
f(I, O) = I
f(O, I) = I
f(I, I) = O
```
"""
function truth_table(fn::Function) ::String
    n = length(first(methods(fn)).sig.parameters) - 1
    # Generate all combinations of true/false for `n` arguments
    combinations = Iterators.product(fill((Bit(0), Bit(1)), n)...)
    # Initialize an empty string to accumulate results
    result_string = ""
    # Evaluate the function for each combination and append it to the 
    # result string
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
≣: ((Bit^n -> Any),(Bit^m -> Any)) -> Bool
(f1,f2) ↦ f1 ≣ f2
```
retruns true only if for all inputs f1 and f2 you get the same output
"""
function ≣(f1::Function, f2::Function) ::Bool
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