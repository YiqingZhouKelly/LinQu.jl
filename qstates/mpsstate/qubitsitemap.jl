
struct QubitSiteMap
	siteForQubit::Vector{Int}
	qubitAtSite::Vector{Int}
	QubitSiteMap(N::Int) = new([1:1:N;],[1:1:N;])
end #struct

siteForQubit(map::QubitSiteMap, i::Int) = map.siteForQubit[i]
sitesForQubits(map::QubitSiteMap, inds::Vector{Int}) = [siteForQubit(map,i) for i ∈ inds]
qubitAtSite(map::QubitSiteMap, i::Int) = map.qubitAtSite[i]
qubitsAtSites(map::QubitSiteMap, inds::Vector{Int}) = [qubitAtSite(map,i) for i ∈ inds]

function updateMap!(map::QubitSiteMap, tup:: T) where T <: Union{NamedTuple{(:s, :q),Tuple{Int64,Int64}}, 
																  NamedTuple{(:q, :s),Tuple{Int64,Int64}}}
	map.siteForQubit[tup.q] = tup.s
	map.qubitAtSite[tup.s] = tup.q
	return map
end