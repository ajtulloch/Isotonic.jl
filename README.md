# Isotonic

## Isotonic Regression in Julia

[![Build Status](https://travis-ci.org/ajtulloch/Isotonic.jl.png)](https://travis-ci.org/ajtulloch/Isotonic.jl)

This implements several algorithms for isotonic regression in Julia.

## Algorithms

+ Linear PAVA (fastest)
+ Pooled PAVA (slower)
+ Active Set (slowest)

## Demonstration

See the [iJulia Notebook][] for a demonstration of usage (and some
performance numbers).

```julia
julia> isotonic_regression([1.0, 2.0, 3.0, 4.0])
4-element Array{Float64,1}:
 1.0
 2.0
 3.0
 4.0
```

[iJulia Notebook]: http://nbviewer.ipython.org/url/gist.githubusercontent.com/ajtulloch/9456289/raw/7a3429ffdb155d5f652f241475af9fdf4a28d2d1/Julia.ipynb

