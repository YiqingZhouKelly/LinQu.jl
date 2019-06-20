struct QubitSiteMap
	siteForQubit::Vector{Int}
	qubitAtSite::Vector{Int}
	QubitSiteMap(N::Int) = new([1:1:N;],[1:1:N;])
end #struct

