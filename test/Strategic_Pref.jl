function strategic_pref(m_prefs::Vector{Vector{Int}},
                        f_prefs::Vector{Vector{Int}},
                        m_matched::Vector{Int},
                        f_matched::Vector{Int},
                        no_f::Int,
                        false_prefs::Vector{Int})
    n = length(f_matched)
    f_first = zeros(Int64, n)
    for i in 1:n
        if f_matched[i] == f_prefs[i][1]
            f_first[i] = 1
        end
    end

    for i in 1:n
        if f_first[i] == 0

    f_new_prefs = copy(f_prefs)
    f_new_prefs[no_f] = false_prefs

    m_new_matched, f_new_matched = my_deferred_acceptance(m_prefs, f_new_prefs)

    if findfirst(f_prefs, f_new_matched[no_f]) < findfirst(f_prefs, f_matched[no_f])
        return no_f, false_prefs
    else
        print("false")
    end
end
