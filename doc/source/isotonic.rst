Isotonic Regression
===================

Each algorithm is implemented as both a function that mutates a vector of
regressors with an optional weight vector or as a non-mutating version
of the same function. As is idiomatic in Julia, we denote the mutating versions
by a an exclamation mark (!).

.. code-block:: julia

   isotonic_regression(y::Vector{Float64}, weights::Vector{Float64})
   isotonic_regression!(y::Vector{Float64}, weights::Vector{Float64})

There are additional overloads for the case where the weight vector is
simply the ones vector.
