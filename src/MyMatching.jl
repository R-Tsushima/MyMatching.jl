module MyMatching

export deferred_acceptance

function deferred_acceptance(m_prefs::Vector{Vector{Int}},f_prefs::Vector{Vector{Int}})
    m_size = length(m_prefs)
    f_size = length(f_prefs)
    m_matched = zeros(Int64,m_size)
    f_matched = zeros(Int64,f_size)
    m_prp = ones(Int64,m_size)
    for j in 1:f_size
        for i in 1:m_size
            if m_prp[i] > length(m_prefs[i])
                m_matched[i] = 0
            elseif m_matched[i] == 0 && m_prp[i] <= length(m_prefs[i])
                if f_matched[m_prefs[i][m_prp[i]]] == 0
                    if findfirst(f_prefs[m_prefs[i][m_prp[i]]], i) == 0
                        f_matched[m_prefs[i][m_prp[i]]] = 0
                        m_matched[i] = 0
                        m_prp[i]+=1
                    else
                        f_matched[m_prefs[i][m_prp[i]]] = i
                        m_matched[i] = m_prefs[i][m_prp[i]]
                        m_prp[i]+=1
                    end
                else
                    if findfirst(f_prefs[m_prefs[i][m_prp[i]]], i) == 0 || findfirst(f_prefs[m_prefs[i][m_prp[i]]], f_matched[m_prefs[i][m_prp[i]]]) < findfirst(f_prefs[m_prefs[i][m_prp[i]]], i)
                        m_matched[i] = 0
                        m_prp[i]+=1
                    else
                        m_matched[f_matched[m_prefs[i]][m_prp[i]]] = 0
                        m_matched[i] = m_prefs[i][m_prp[i]]
                        f_matched[m_prefs[i][m_prp[i]]] = i
                        m_prp[i]+=1
                    end
                end
            end
        end
    end
    return(m_matched,f_matched)
end

end
