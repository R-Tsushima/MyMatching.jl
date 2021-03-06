#多対一のケース
function deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                             resp_prefs::Vector{Vector{Int}},
                             caps::Vector{Int})
    m = length(prop_prefs)
    n = length(resp_prefs)
    prop_matched = zeros(Int64,m)
    resp_matched = zeros(Int64,sum(caps))
    count = ones(Int64,m)
    accept = zeros(Int64,n)
    indptr = Array{Int}(n+1)
    indptr[1] = 1
    for i in 1:n
        indptr[i+1] = indptr[i] + caps[i]
    end

    for j in 1:n
        for i in 1:m
            if prop_matched[i] == 0 && count[i] <= length(prop_prefs[i])
                k = prop_prefs[i][count[i]]
                if findfirst(resp_prefs[k], i) != 0
                    if accept[k] < caps[k]
                        resp_matched[indptr[k+1]-1 - accept[k]] = i
                        prop_matched[i] = k
                        accept[k]+=1
                    else
                        list = resp_matched[indptr[k]:indptr[k+1]-1]
                        ranking = zeros(Int64,caps[k])
                        for l in 1:caps[k]
                            ranking[l] = findfirst(resp_prefs[k], list[l])
                        end
                        if 0 < findfirst(resp_prefs[k], i) < maximum(ranking)
                            resp_matched[indptr[k] + indmax(ranking) - 1] = i
                            prop_matched[list[indmax(ranking)]] = 0
                            prop_matched[i] = k
                        end
                    end
                end
                count[i]+=1
            end
        end
    end
    return prop_matched, resp_matched, indptr
end

#一対一のケース
function deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}})
    caps = ones(Int, length(resp_prefs))
    prop_matched, resp_matched, indptr =
        deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matched, resp_matched
end

function deferred_acceptance(m_prefs::Vector{Vector{Int}},f_prefs::Vector{Vector{Int}})
    m_size = length(m_prefs)
    f_size = length(f_prefs)
    m_matched = zeros(Int64,m_size)
    f_matched = zeros(Int64,f_size)
    m_prp = ones(Int64,m_size)
    for j in 1:f_size
        for i in 1:m_size
            if m_matched[i] == 0 && m_prp[i] <= length(m_prefs[i])
                if findfirst(f_prefs[m_prefs[i][m_prp[i]]], i) != 0
                    if f_matched[m_prefs[i][m_prp[i]]] == 0
                        f_matched[m_prefs[i][m_prp[i]]] = i
                        m_matched[i] = m_prefs[i][m_prp[i]]
                    else
                        if 0 < findfirst(f_prefs[m_prefs[i][m_prp[i]]], i) < findfirst(f_prefs[m_prefs[i][m_prp[i]]], f_matched[m_prefs[i][m_prp[i]]])
                            m_matched[f_matched[m_prefs[i][m_prp[i]]]] = 0
                            m_matched[i] = m_prefs[i][m_prp[i]]
                            f_matched[m_prefs[i][m_prp[i]]] = i
                        end
                    end
                end
                m_prp[i]+=1
            end
        end
    end
    return(m_matched,f_matched)
end
