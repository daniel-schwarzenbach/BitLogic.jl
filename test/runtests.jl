using BitLogic
using Test

@testset "BitLogic.jl" begin
    @test I ∨ O == I
    ≡ = ≣
    f1(a,b) = a → ¬b
    f2(a,b) = a ↑ b
    @test f1 ≡ f2
    f3(a,b) = ¬(a ∨ b)
    f4(a,b) = ¬a ∧ ¬b
    @test f3 ≡ f4 # De Morgan

    Byte::DataType = NTuple{8,Bit}
    _7_::Byte = (O,O,O,O,O,I,I,I)
    println(_7_)
end
