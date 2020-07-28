using SantasLittleHelpers
using Test
using Statistics, StatsBase, Dates, DataFrames



@testset "Simple Functions" begin
    x = rand(100)
    @test loggrowth(x)[end] ≈ 100*diff(log.(x))[end]
    @test autocorrelate(x) ≈ first(autocor(x,[1]))
    @test autocorrelate(abs,x) ≈ first(autocor(abs.(x),[1]))
    @test logdiff(x[1:4]) ≈ log(x[4])-log(x[1])

    @test monthtoquarter(12) == 4
    @test yrqtrfun(Date(2018,1,1)) == "2018Q1"

    @test simiterator(10,3)[end] == 4
    @test perioditerator(10,3)[end] == 1
end

@testset "Harder Functions" begin
    x = rand(100)

    varx = var(x)
    x2 = [sum(x[i-1:i]) for i in 2:100]
    testvr2 = var(x2) / (2*varx)

    @test varianceratio(x,1) == 1
    @test varianceratio(x,2) ≈ vr2(x)
    @test vr2(x) ≈ testvr2

    @test applyrolling(sum,x,-1:0,missing)[end] ≈ x2[end]
    @test applyrolling(makekernel(sum,-1:0),x,missing)[end] ≈ x2[end]
end


@testset "DataFrames" begin
    df = DataFrame(x=[1,2,NaN,3],y=[NaN,2,3,4])
    nantomissing!(df,:x)
    @test ismissing(df.x[3])
    nantomissing!(df)
    @test ismissing(df.y[1])
end






