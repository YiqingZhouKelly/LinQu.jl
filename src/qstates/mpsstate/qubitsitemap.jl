
struct QubitSiteMap
	siteForQubit::Vector{Int}
	qubitAtSite::Vector{Int}
	QubitSiteMap(N::Int) = new([1:N;],[1:N;])
	QubitSiteMap(siteForQubit::Vector{Int}, qubitAtSite::Vector{Int}) = new(siteForQubit,qubitAtSite)
end #struct
copy(map::QubitSiteMap) = QubitSiteMap(copy(map.siteForQubit), copy(map.qubitAtSite))

siteForQubit(map::QubitSiteMap, i::Int) = map.siteForQubit[i]
sitesForQubits(map::QubitSiteMap, inds::Vector{Int}) = [siteForQubit(map,i) for i ∈ inds]
qubitAtSite(map::QubitSiteMap, i::Int) = map.qubitAtSite[i]
qubitsAtSites(map::QubitSiteMap, inds::Vector{Int}) = [qubitAtSite(map,i) for i ∈ inds]

function updateMap!(map::QubitSiteMap; kwargs...)
	q = get(kwargs, :q, -1)
	s = get(kwargs, :s, -1)
	map.siteForQubit[q] = s
	map.qubitAtSite[s] = q
end
