using Isotonic
using Base.Test

ys = map(Float64, [1, 41, 51, 1, 2, 5, 24])
ws = map(Float64, [1, 2, 3, 4, 5, 6, 7])
expected = [1.0, 13.95, 13.95, 13.95, 13.95, 13.95, 24]
for f in [pooled_pava_isotonic_regression, isotonic_regression, active_set_isotonic_regression]
    @test all(abs(f(ys, ws) .- expected) .< 0.01)

    # Additional tests originally from MultipleTesting.jl package:

    #pooled adjacent violators example page 10 robertson
    @test_approx_eq f([22.5; 23.333; 20.833; 24.25], [3.0;3.0;3.0;2.0]) [22.222; 22.222; 22.222; 24.25]

    #if input already ordered, then output should be the same
    @test_approx_eq f([1.0; 2.0; 3.0]) [1.0; 2.0; 3.0]

    @test_approx_eq f([1., 41., 51., 1., 2., 5., 24.], [1., 2., 3., 4., 5., 6., 7.]) [1.0, 13.95, 13.95, 13.95, 13.95, 13.95, 24]

    # single value or empty vector remains unchanged
    r = rand(1)
    @test f(r) == r
    r = Vector{Float64}()
    @test f(r) == r

    r = rand(10)
    @test f(r, ones(r)) == f(r)
    @test_throws DimensionMismatch f(rand(10), ones(5))
end

