using Isotonic
using Test

ys = map(Float64, [1, 41, 51, 1, 2, 5, 24])
ws = map(Float64, [1, 2, 3, 4, 5, 6, 7])
expected = [1.0, 13.95, 13.95, 13.95, 13.95, 13.95, 24]

iso_dict = Dict(:PooledPava => (pooled_pava_isotonic_regression, pooled_pava_isotonic_regression!),
                :LinearPava => (isotonic_regression, isotonic_regression!),
                :ActiveSet  => (active_set_isotonic_regression, active_set_isotonic_regression!))

for ( k,v ) in iso_dict
    println(k)
    f  = v[1]
    f! = v[2]
    @test all(abs.(f(ys, ws) .- expected) .< 0.01)

    # test if non-mutating or mutating
    @test f(ys, ws) == f!(copy(ys),ws)
    ys_copy = copy(ys)
    fys = f(ys_copy,ws)
    @test ys==ys_copy
    fmut_ys = f!(ys_copy, ws)
    @test ys != ys_copy
    @test ys_copy == fmut_ys
    # Additional tests originally from MultipleTesting.jl package:

    #pooled adjacent violators example page 10 robertson
    @test f([22.5; 23.333; 20.833; 24.25], [3.0;3.0;3.0;2.0]) ≈ [22.222; 22.222; 22.222; 24.25]

    #if input already ordered, then output should be the same
    @test f([1.0; 2.0; 3.0]) ≈ [1.0; 2.0; 3.0]

    @test f([1., 41., 51., 1., 2., 5., 24.], [1., 2., 3., 4., 5., 6., 7.]) ≈ [1.0, 13.95, 13.95, 13.95, 13.95, 13.95, 24]

    # single value or empty vector remains unchanged
    r = rand(1)
    @test f(r) == r
    r = Vector{Float64}()
    @test f(r) == r

    r = rand(10)
    @test f(r, fill!(similar(r), 1)) == f(r)
    @test_throws DimensionMismatch f(rand(10), ones(5))
end
