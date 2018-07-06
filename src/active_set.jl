struct ActiveState
    weighted_label::Float64
    weight::Float64
    lower::Int64
    upper::Int64

end

function merge_state(l::ActiveState, r::ActiveState)
    return ActiveState(l.weighted_label + r.weighted_label,
                       l.weight + r.weight,
                       l.lower,
                       r.upper)
end

function below(l::ActiveState, r::ActiveState)
    return l.weighted_label * r.weight <= l.weight * r.weighted_label
end

function active_set_isotonic_regression!(y::Vector{Float64}, weights::Vector{Float64})

    n = length(y)
    if n <= 1
        return y
    end
    if n != length(weights)
        throw(DimensionMismatch("Lengths of values and weights mismatch"))
    end

    @inbounds begin
        active_set = [ActiveState(weights[i] * y[i], weights[i], i, i) for i in 1 : n]
        current = 1
        while current < size(active_set, 1)
            while current < size(active_set, 1) && below(active_set[current], active_set[current+1])
                current += 1
            end
            if current == size(active_set, 1)
                break
            end

            merged = merge_state(active_set[current], active_set[current+1])
            splice!(active_set, current:current+1, [merged])
            while current > 1 && !below(active_set[current-1], active_set[current])
                current -= 1
                merged = merge_state(active_set[current], active_set[current+1])
                splice!(active_set, current:current+1, [merged])
            end
        end

        for as in active_set
            y[as.lower:as.upper] .= as.weighted_label / as.weight
        end
    end
    return y
end

active_set_isotonic_regression!(y::Vector{Float64}) = active_set_isotonic_regression!(y, ones(size(y, 1)))

# non-mutating versions
active_set_isotonic_regression(y::Vector{Float64}, weights::Vector{Float64}) = active_set_isotonic_regression!(copy(y), weights)
active_set_isotonic_regression(y::Vector{Float64}) = active_set_isotonic_regression(y, ones(size(y,1)))
