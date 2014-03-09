using Base.Test
using Isotonic

ys = float64([1, 41, 51, 1, 2, 5, 24])
ws = float64([1, 2, 3, 4, 5, 6, 7])
expected = [1.0, 13.95, 13.95, 13.95, 13.95, 13.95, 24]
for f in [pooled_pava_isotonic_regression, isotonic_regression, active_set_isotonic_regression]
    @test all(abs(f(ys, ws) .- expected) .< 0.01)
end
