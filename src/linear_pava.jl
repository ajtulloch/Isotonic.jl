function isotonic_regression!(y::Vector{Float64}, weights::Vector{Float64})

    n = length(y)
    if n <= 1
        return y
    end
    if n != length(weights)
        throw(DimensionMismatch("Lengths of values and weights mismatch"))
    end

    @inbounds begin
        n -= 1
        while true
            i = 1
            pooled = 0
            while i <= n
                k = i
                while k <= n && y[k] >= y[k+1]
                    k += 1
                end

                # Find a decreasing subsequence, and update
                # all points in the sequence to the weighted average.
                if y[i] != y[k]
                    numerator = 0.0
                    denominator = 0.0
                    for j in i : k
                        numerator += y[j] * weights[j]
                        denominator += weights[j]
                    end

                    for j in i : k
                        y[j] = numerator / denominator
                    end
                    pooled = 1
                end
                i = k + 1
            end
            if pooled == 0
                break
            end
        end
    end
    return y
end

isotonic_regression!(y::Vector{Float64}) = isotonic_regression!(y, ones(size(y, 1)))

# non-mutating versions
isotonic_regression(y::Vector{Float64}, weights::Vector{Float64}) = isotonic_regression!(copy(y), weights)
isotonic_regression(y::Vector{Float64}) = isotonic_regression(y, ones(size(y,1)))
