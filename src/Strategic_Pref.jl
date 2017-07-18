function strategic_pref(m_prefs::Vector{Vector{Int}},
                        f_prefs::Vector{Vector{Int}},
                        m_matched::Vector{Int},
                        f_matched::Vector{Int},
                        P_count::Vector{Int},
                        no_f::Vector{Int},
                        false_prefs::Vector{Vector{Int}})
    m = length(m_prefs)
    n = length(f_prefs)
    results = fill([0], (n, factorial(m)))
    f_require = zeros(Int64, n)
    for i in 1:n
        if f_matched[i] == f_prefs[i][1]
            f_require[i] = 1
        end
        if p_count[i] <= 1
            f_require[i]+=10
        end
    end

    for i in 1:n
        if f_require[i] == 0
            f_new_prefs = copy(f_prefs)
            for j in 1:factorial(m)
                f_new_prefs[i] = false_prefs[j]
                m_new_matched, f_new_matched = my_deferred_acceptance(m_prefs, f_new_prefs)
                if findfirst(f_prefs, f_new_matched[i]) < findfirst(f_prefs, f_matched[i])
                    results[i][j] = false_prefs[j]
                end
            end
        end
    end
end
