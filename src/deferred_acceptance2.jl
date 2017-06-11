function deferred_acceptance(m_prefs,f_prefs)
    m_size = size(m_prefs,2)
    f_size = size(f_prefs,2)
    m_matched = zeros(Int64,m_size)
    f_matched = zeros(Int64,f_size)
    m_prp = ones(Int64,m_size)
    for j in 1:f_size
        for i in 1:m_size
            if m_matched[i] == 0 && m_prp[i] < (f_size+2)
                if m_prefs[m_prp[i],i] == 0
                    m_matched[i] = 0
                    m_prp[i] = f_size+2
                else
                    if f_matched[m_prefs[m_prp[i],i]] == 0
                        if findfirst(f_prefs[:,m_prefs[m_prp[i],i]],0) < findfirst(f_prefs[:,m_prefs[m_prp[i],i]],i)
                            f_matched[m_prefs[m_prp[i],i]] = 0
                            m_matched[i] = 0
                            m_prp[i]+=1
                        else
                            f_matched[m_prefs[m_prp[i],i]] = i
                            m_matched[i] = m_prefs[m_prp[i],i]
                            m_prp[i]+=1
                        end
                    else
                        if findfirst(f_prefs[:,m_prefs[m_prp[i],i]],f_matched[m_prefs[m_prp[i],i]]) < findfirst(f_prefs[:,m_prefs[m_prp[i],i]],i)
                            m_matched[i] = 0
                            m_prp[i]+=1
                        else
                            m_matched[f_matched[m_prefs[m_prp[i],i]]] = 0
                            m_matched[i] = m_prefs[m_prp[i],i]
                            f_matched[m_prefs[m_prp[i],i]] = i
                            m_prp[i]+=1
                        end
                    end
                end
            end
        end
    end
    return(m_matched,f_matched)
end
