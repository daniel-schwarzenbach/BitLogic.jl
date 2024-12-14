using BitLogic
using Test

@testset "BitLogic.jl" begin
    ≡ = ≣
    f1(a,b) = a → ¬b
    f2(a,b) = a ↑ b
    @test f1 ≡ f2
    f3(a,b) = ¬(a ∨ b)
    f4(a,b) = ¬a ∧ ¬b
    @test f3 ≡ f4 # De Morgan
end
