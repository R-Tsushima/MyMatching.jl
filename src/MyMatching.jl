module MyMatching

export deferred_acceptance

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
            k = prop_prefs[i][count[i]]
            if prop_matched[i] == 0 && count[i] <= length(prop_prefs[i])
                if findfirst(resp_prefs[k], i) != 0
                    if accept[k] < caps[k]
                        resp_matched[indptr[k+1]-1 - accept[k]] = i
                        prop_matched[i] = k
                        accept[k]+=1
                    else
                        list = resp_matched[indptr[k]:indptr[k+1]-1]
                        ranking = zeros(Int64,caps[k])
                        for l in 1:caps[k]
                            ranking[l] = findfirst(resp_prefs[prop_prefs[i][count[i]]], list[l])
                        end
                        if 0 < findfirst(resp_prefs[prop_prefs[i][count[i]]], i) < maximum(ranking)
                            resp_matched[indptr[k] + indmax(ranking) - 1]
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
    prop_matches, resp_matches, indptr =
        deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matches, resp_matches
end

end
