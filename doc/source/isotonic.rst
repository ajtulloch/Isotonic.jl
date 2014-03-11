Isotonic Regression
===================

Each algorithm is implemented as a function that mutatates a vector of
regressors with an optional weight vector.

.. code-block:: julia

   isotonic_regression(y::Vector{Float64}, weights::Vector{Float64})

There are additional overloads for the case where the weight vector is
simply the ones vector.
