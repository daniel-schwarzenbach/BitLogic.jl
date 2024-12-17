using BitLogic
using Test

@testset "BitLogic.jl" begin
    @test 𝟏 ∨ 𝟎 == 𝟏
    ≡ = ≣
    f1(a,b) = a → ¬b
    f2(a,b) = a ↑ b
    @test f1 ≡ f2
    f3(a,b) = ¬(a ∨ b)
    f4(a,b) = ¬a ∧ ¬b
    @test f3 ≡ f4 # De Morgan

    Byte::DataType = NTuple{8,Bit}
    _7_::Byte = (𝟎,𝟎,𝟎,𝟎,𝟎,𝟏,𝟏,𝟏)
    println(_7_)

    bitvec::Vector{Bit} =  0b0111
    println(bitvec)
    d::Int = bitvec
    @test d == 7
end
