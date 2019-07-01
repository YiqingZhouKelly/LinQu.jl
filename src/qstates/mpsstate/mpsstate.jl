
mutable struct MPSState
	sites::Vector{ITensor}
	map::QubitSiteMap
	llim::Int
	rlim::Int
	MPSState(sites::Vector{ITensor},
		     map::QubitSiteMap,
		     llim::Int,
		     rlim::Int) = new(sites, map, llim, rlim)

	function MPSState(N::Int, init::Vector{T}) where {T <:Number}
		sites = ITensor[]
		rightlink,leftlink
		for i =1:N
			global rightlink, leftlink
			if i ==1
				rightlink = Index(1, "Link, l=$(i)")
				push!(sites, ITensor(init, rightlink,Index(2, "Site, q=$(i)")))
			elseif i == N
				push!(sites, ITensor(init, leftlink, Index(2, "Site, q=$(i)")))
			else
				rightlink = Index(1, "Link, l=$(i)")
				push!(sites, ITensor(init, leftlink, rightlink, Index(2, "Site, q=$(i)")))
			end
			leftlink = rightlink
		end
		new(sites,QubitSiteMap(N),0,N+1)
	end
	MPSState(N::Int) = MPSState(N, [1,0])
end #struct
getindex(state::MPSState, n::Int) = getindex(state.sites,n)
getinds(state::MPSState, inds::Vector{Int}) = [getindex(state, i) for i ∈ inds]
setindex!(state::MPSState, T::ITensor, n::Integer) = setindex!(state.sites, T, n)
length(state::MPSState) = length(state.sites)
size(state::MPSState) = size(state.sites)
iterate(state::MPSState, itstate::Int=1) = iterate(state.sites,itstate)

siteForQubit(state::MPSState, i::Int) = siteForQubit(state.map,i)
sitesForQubits(state::MPSState, inds::Vector{Int}) = sitesForQubits(state.map, inds)
qubitAtSite(state::MPSState, i::Int) = qubitAtSite(state.map, i)
qubitsAtSites(state::MPSState, inds::Vector{Int}) = qubitsAtSites(state.map, inds)

updateMap!(state::MPSState, tuple) = updateMap!(state.map, tuple)
function updateLims!(state::MPSState, leftEnd::Int, rightEnd::Int)
	state.llim >= leftEnd && (state.llim = leftEnd-1)
	state.rlim <= rightEnd && (state.rlim = rightEnd+1)
	return state
end
updateLims!(state::MPSState, touchedSite::Int) = updateLims!(state, touchedSite, touchedSite)

getQubit(state::MPSState, i::Int) = state.sites[siteForQubit(state,i)]
getQubits(state::MPSState, inds::Vector{Int}) = [getQubit(state, i) for i ∈ inds]
siteIndex(state::MPSState, i::Int) = findindex(state[i], "Site")
siteInds(state::MPSState, inds::Vector{Int}) = IndexSet([siteIndex(state, i) for i ∈ inds])

toExactState(state::MPSState) = ExactState(prod(state.sites))

# apply!(state::MPSState, gate::MeasureGate) = collapseQubits!(state, qubits(gate); reset=reset(gate))
function measure!(state::MPSState, qubits::Vector{Int}, shots::Int; kwargs...)
	localizeQubitsInOrder!(state, qubits; kwargs...)
	sites = sitesForQubits(state, qubits)
	centerAtSite!(state, sites[1])
	counts = zeros(2^(length(qubits)))
	function binaryToDecimal(binary::Vector{Int})
		decimal = zeros(Int,1)
		for i =1:length(binary)
			decimal[1] = decimal[1]*2+binary[i]
		end
		return decimal[1]
	end
	for i =1:shots
		sampleDecimal = binaryToDecimal(oneShot(state, sites; kwargs...))
		counts[sampleDecimal+1] += 1
	end
	return counts
end

function orderQubits!(state::MPSState; kwargs...)
	for q = 1:length(state)
		moveQubit!(state, q, q; kwargs...)
	end
end

function moveSite!(state::MPSState, s::Int, t::Int; kwargs...)
	while s < t
		swapSites!(state, s, s+1; kwargs...)
		s += 1
	end
	while s > t
		swapSites!(state, s-1, s; kwargs...)
		s -= 1
	end
end

moveQubit!(state::MPSState, q::Int, s::Int; kwargs...) = moveSite!(state, siteForQubit(state,q), s; kwargs...)

function localizeQubits!(state::MPSState, actpos::ActPosition; kwargs...)
	sortedSites = sort(sitesForQubits(state, actpos.qubits))

	for i = 2: length(sortedSites)
		moveSite!(state, sortedSites[i], sortedSites[i-1]+1; kwargs...)
		sortedSites[i] = sortedSites[i-1]+1
	end

	return state
end

function localizeQubitsInOrder!(state::MPSState, qubits::Vector{Int}; kwargs...)
	for i = 1:length(qubits)
		moveQubit!(state, qubits[i], i; kwargs...)
	end
end

function centerAtSite!(state::MPSState, s::Int)
	while state.llim < s-1
		currIndex = state.llim+1
		curr = state[currIndex]
		if currIndex != 1 
			Q,R = qr(curr, findindex(curr,"Site"), findindex(curr, "l=$(currIndex-1)"))
		else
			Q,R = qr(curr, findindex(curr,"Site"))
		end
		state[currIndex] = replacetags(Q, "u", "l=$(currIndex)")
		state[currIndex+1] = replacetags(state[currIndex+1]*R , "u", "l=$(currIndex)")
		state.llim+=1
	end

	while state.rlim > s+1
		currIndex = state.rlim-1
		curr = state[currIndex]
		if currIndex != length(state)
			Q,R = qr(curr, findindex(curr, "Site"), findindex(curr, "l=$(currIndex)"))
		else
			Q,R = qr(curr, findindex(curr, "Site"))
		end
		state[currIndex] = replacetags(Q, "u", "l=$(currIndex-1)")
		state[currIndex-1] = replacetags(state[currIndex-1]*R , "u", "l=$(currIndex-1)")
		state.rlim-=1
	end

	state.llim = s-1
	state.rlim = s+1
	state[s] /= norm(state[s])
	return state
end

centerAtQubit!(state::MPSState, q::Int) = centerAtSite!(state, siteForQubit(state, q))



function swapSites!(state::MPSState, s1::Int, s2::Int, decomp= "qr"; kwargs...)
	s1 > s2 && ((s1, s2) = (s2, s1))
	(s2 != s1+1) && error("swapSites can only swap two neighbor sites")
	(q1, q2) = (qubitAtSite(state, s1), qubitAtSite(state, s2))
	product = state[s1] * state[s2]
	if decomp =="svd"
		if s1 > 1
			leftinds = IndexSet(findindex(product, "l=$(s1-1)"), 
								findindex(product, "q=$(q2)"))
			U,S,V,u,v = svd(product, leftinds; kwargs...)
		else
			U,S,V,u,v = svd(product, findindex(product, "q=$(q2)"); kwargs...)
		end
		state[s1] = replacetags(U,"u", "l=$(s1)")
		state[s2] = replacetags(S*V,"u", "l=$(s1)")
	else #qr
		if s1 > 1
			leftinds = IndexSet(findindex(product, "l=$(s1-1)"), 
								findindex(product, "q=$(q2)"))
			Q,R = qr(product, leftinds)
		else
			Q,R = qr(product, findindex(product, "q=$(q2)"))
		end
		state[s1] = replacetags(Q,"u", "l=$(s1)")
		state[s2] = replacetags(R,"u", "l=$(s1)")
	end
	updateMap!(state, (s=s1, q=q2))
	updateMap!(state, (s=s2, q=q1))
	state.llim >= s1 && (state.llim = s1-1)
	state.rlim <= s2 && (state.rlim = s2+1)
end

function projector(i::Int, ind::Index)
		data = zeros(2)
		data[i] = 1
		return ITensor(data, ind)
end

function oneShot(state::MPSState, sites::Vector{Int}; kwargs...)
	sample = zeros(Int, length(sites))
	clamped = nothing
	for i =1:length(sites)
		ψ = state[sites[i]]
		clamped != nothing && (ψ *= clamped)
		ψ0 = ψ*projector(1, findindex(ψ, "Site"))
		prob0 = Real(scalar(ψ0 * dag(ψ0)))
		ψ1 = ψ*projector(2, findindex(ψ, "Site"))
		prob1 = Real(scalar(ψ1 * dag(ψ1)))
		prob0 /= (prob0+prob1)
		if rand(0:10000)/10000 > prob0
			sample[i] = 1
			clamped = ψ1
		else
			clamped = ψ0
		end 
	end
	return sample
end

function collapseQubits!(state::MPSState, qubits::Vector{Int}; reset=false)
	results = zeros(Int, length(qubits))
	for i = 1:length(qubits)
		site = siteForQubit(state, qubits[i])
		centerAtSite!(state, site)
		ψ = state[site]
		proj0 = projector(1, findindex(ψ, "Site"))
		ψ0 = ψ*proj0
		proj1 = projector(2, findindex(ψ, "Site"))
		ψ1 = ψ*proj1
		prob0 = Real(scalar(ψ0 * dag(ψ0)))
		prob1 = Real(scalar(ψ1 * dag(ψ1)))
		if rand(0:10000)/10000 < prob0
			state[site] = ψ1*proj0
			printstyled("0", bold=true, color=5)
		else
			results[i] = 1
			printstyled("1", bold=true, color=43)
			if reset
				state[site] = ψ1*proj0
			else 	
				state[site] = ψ1*proj1
			end
		end 
		updateLims!(state, site)
	end
	return results
end
collapseQubit!(state::MPSState, qubit::Int; reset=false) = collapseQubits!(state, [qubits]; reset= reset)[1]

function showStructure(io::IO, state::MPSState)
	printstyled(io, "siteForQubit:"; bold=true, color=:blue)
	print(io, state.map.siteForQubit, "\n")
	printstyled(io, "qubitAtSite:"; bold=true, color=:blue)
	print(io, state.map.qubitAtSite, "\n")
	printstyled(io, "llim = $(state.llim), rlim = $(state.rlim)\n", bold=true, color=:blue)
	printstyled(io, "-------------------\n"; bold=true, color=5)
end
function show(io::IO, state::MPSState)
	printstyled(io, "--- MPS state: ---\n"; bold=true, color=5)
	for i =1: length(state)
		printstyled(io, "Site $(i):"; bold=true, color=43)
		print(io, IndexSet(state.sites[i]),"\n")
	end
	showStructure(io, state)
end

function showData(io::IO,state::MPSState)
	printstyled("--- MPS state: ---\n"; bold=true, color=5)
	for i =1: length(state)
		printstyled(io, "Site $(i):\n"; bold=true, color=43)
		print(io, state[i],"\n")
	end
	showStructure(io, state)
end
showData(state::MPSState) = showData(stdout, state)
