function pooled_pava_isotonic_regression!(y::Vector{Float64}, weights::Vector{Float64})

    n = length(y)
    if n <= 1
        return y
    end
    if n != length(weights)
        throw(DimensionMismatch("Lengths of values and weights mismatch"))
    end

    j = 1
    S = Dict(0 => 0, 1 => 1)
    ydash = Dict(1 => y[1])
    wdash = Dict(1 => weights[1])
    @inbounds begin
        for i in 2 : n
            j = j + 1
            ydash[j] = y[i]
            wdash[j] = weights[i]
            while j > 1 && ydash[j] < ydash[j-1]
                ydash[j-1] = (wdash[j] * ydash[j] + wdash[j-1] * ydash[j-1]) /
                   (wdash[j] + wdash[j-1])
                wdash[j-1] = wdash[j] + wdash[j-1]
                j = j-1
            end
            S[j] = i
        end
        for k in 1 : j
            for l in S[k-1] + 1 : S[k]
                y[l] = ydash[k]
            end
        end
    end
    return y
end

pooled_pava_isotonic_regression!(y::Vector{Float64}) = pooled_pava_isotonic_regression!(y, ones(size(y, 1)))

# non-mutating versions
pooled_pava_isotonic_regression(y::Vector{Float64}, weights::Vector{Float64}) = pooled_pava_isotonic_regression!(copy(y), weights)
pooled_pava_isotonic_regression(y::Vector{Float64}) = pooled_pava_isotonic_regression(y, ones(size(y,1)))
