
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

# function updateMap!(map::QubitSiteMap, tup:: T) where T <: Union{ NamedTuple{(:s, :q),Tuple{Int64,Int64}}, 
# 																 NamedTuple{(:q, :s),Tuple{Int64,Int64}}}
# 	map.siteForQubit[tup.q] = tup.s
# 	map.qubitAtSite[tup.s] = tup.q
# 	return map
# end

function updateMap!(map::QubitSiteMap; kwargs...)
	println("calling updateMap")
	q = get(kwargs, :q, error("q not specified"))
	s = get(kwargs, :s, error("s not specified"))
	map.siteForQubit[q] = s
	map.siteForQubit[s] = q
end