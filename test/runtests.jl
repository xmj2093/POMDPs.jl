using Test

using POMDPs
using Random

@testset "infer" begin
    include("test_inferrence.jl")
end

@testset "generative" begin
    include("test_generative.jl")
end

@testset "genback" begin
    include("test_generative_backedges.jl")
end

struct CI <: POMDP{Int,Int,Int} end
struct CV <: POMDP{Vector{Float64},Vector{Float64},Vector{Float64}} end

@testset "convert" begin
    @test convert_s(Vector{Float32}, 1, CI()) == Float32[1.0]
    @test convert_s(statetype(CI), Float32[1.0], CI()) == 1
    @test convert_s(statetype(CV), Float32[2.0,3.0], CV()) == [2.0, 3.0]
    @test convert_s(Vector{Float32}, [2.0, 3.0], CV()) == Float32[2.0, 3.0]

    @test convert_a(Vector{Float32}, 1, CI()) == Float32[1.0]
    @test convert_a(statetype(CI), Float32[1.0], CI()) == 1
    @test convert_a(statetype(CV), Float32[2.0,3.0], CV()) == [2.0, 3.0]
    @test convert_a(Vector{Float32}, [2.0, 3.0], CV()) == Float32[2.0, 3.0]

    @test convert_o(Vector{Float32}, 1, CI()) == Float32[1.0]
    @test convert_o(statetype(CI), Float32[1.0], CI()) == 1
    @test convert_o(statetype(CV), Float32[2.0,3.0], CV()) == [2.0, 3.0]
    @test convert_o(Vector{Float32}, [2.0, 3.0], CV()) == Float32[2.0, 3.0]
end

struct EA <: POMDP{Int, Int, Int} end
@testset "error" begin
    @test_throws MethodError transition(EA(), 1, 2)
    @test_throws DistributionNotImplemented gen(DDNOut(:sp), EA(), 1, 2, Random.GLOBAL_RNG)
end

@testset "history" begin
    POMDPs.history(i::Int) = [(o=i,)]
    @test history(4)[end][:o] == 4
    @test currentobs(4) == 4
end

POMDPs.add_registry()

@testset "deprecated" begin
    @test !@implemented transition(::EA, ::Int, ::Int)
    POMDPs.transition(::EA, ::Int, ::Int) = [0]
    @test @implemented transition(::EA, ::Int, ::Int)
end
