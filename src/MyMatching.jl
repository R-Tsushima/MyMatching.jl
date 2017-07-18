module MyMatching

export my_deferred_acceptance

#many to many

function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                             resp_prefs::Vector{Vector{Int}},
                             p_caps::Vector{Int},
                             r_caps::Vector{Int})
    m = length(prop_prefs)
    n = length(resp_prefs)
    prop_matched = zeros(Int64,sum(p_caps))
    resp_matched = zeros(Int64,sum(r_caps))
    count = ones(Int64,m) #提案側の提案回数
    accept = zeros(Int64,n) #受入側の受入人数
    p_count = zeros(Int64,n) #受入側が提案された回数（選好順位の考察に使用）

#iがマッチングしたリストを表すための変数
    p_indptr = Array{Int}(m+1)
    r_indptr = Array{Int}(n+1)
    p_indptr[1] = 1
    for i in 1:m
        p_indptr[i+1] = p_indptr[i] + p_caps[i]
    end
    r_indptr[1] = 1
    for i in 1:n
        r_indptr[i+1] = r_indptr[i] + r_caps[i]
    end

    for j in 1:sum(p_caps)*sum(r_caps)
        for i in 1:m
            p_list = prop_matched[p_indptr[i]:p_indptr[i+1]-1]
            if count[i] <= length(prop_prefs[i]) && findfirst(p_list, 0) != 0
                k = prop_prefs[i][count[i]] #このラウンドでiが提案する相手k
                if findfirst(resp_prefs[k], i) != 0
                    if accept[k] < r_caps[k]
                        resp_matched[r_indptr[k+1]-1 - accept[k]] = i
                        prop_matched[p_indptr[i] + findfirst(p_list, 0) - 1] = k
                        accept[k]+=1
                    else
                        list = resp_matched[r_indptr[k]:r_indptr[k+1]-1] #受入側kの保留相手のリスト
                        ranking = zeros(Int64,r_caps[k]) #リスト内での保留相手の順序とkのそれぞれの選好順位を対応させた
                        for l in 1:r_caps[k]
                            ranking[l] = findfirst(resp_prefs[k], list[l])
                        end
                        if 0 < findfirst(resp_prefs[k], i) < maximum(ranking)
                            d_list = prop_matched[p_indptr[list[indmax(ranking)]]:p_indptr[list[indmax(ranking)]+1]-1] #保留から外される提案側のマッチングリスト
                            resp_matched[r_indptr[k] + indmax(ranking) - 1] = i
                            prop_matched[p_indptr[list[indmax(ranking)]] + findfirst(d_list, k) - 1] = 0
                            prop_matched[p_indptr[i] + findfirst(p_list, 0) - 1] = k
                        end
                    end
                end
                count[i]+=1
                p_count[k]+=1
            end
        end
    end
    return prop_matched, resp_matched, p_indptr, r_indptr, p_count
end

#many to one
function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}},
                                r_caps::Vector{Int})
    p_caps = ones(Int, length(prop_prefs))
    prop_matched, resp_matched, p_indptr, r_indptr =
        my_deferred_acceptance(prop_prefs, resp_prefs, p_caps, r_caps)
    return prop_matched, resp_matched, r_indptr
end

#one to one
function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}})
    p_caps = ones(Int, length(prop_prefs))
    r_caps = ones(Int, length(resp_prefs))
    prop_matched, resp_matched, p_indptr, r_indptr, p_count =
        my_deferred_acceptance(prop_prefs, resp_prefs, p_caps, r_caps)
    return prop_matched, resp_matched, p_count
end

end
