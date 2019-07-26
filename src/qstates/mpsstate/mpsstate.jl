
mutable struct MPSState <: QState
	sites::Vector{ITensor}
	map::QubitSiteMap
	llim::Int
	rlim::Int

	MPSState(sites::Vector{ITensor},
		     map::QubitSiteMap,
		     llim::Int,
		     rlim::Int) = new(sites, map, llim, rlim)
end #struct

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
	MPSState(sites,QubitSiteMap(N),0,N+1)
end
MPSState(N::Int) = MPSState(N, [1,0])

getindex(state::MPSState, n::Int) = getindex(state.sites,n)
getinds(state::MPSState, inds::Vector{Int}) = [getindex(state, i) for i ∈ inds]
setindex!(state::MPSState, T::ITensor, n::Integer) = setindex!(state.sites, T, n)
length(state::MPSState) = length(state.sites)
size(state::MPSState) = size(state.sites)
iterate(state::MPSState, itstate::Int=1) = iterate(state.sites,itstate)
copy(state::MPSState) = MPSState(copy.(state.sites), copy(state.map), state.llim, state.rlim)
numQubits(state::MPSState) = length(state)

function isapprox(state1::MPSState, state2::MPSState)
	exact1 = toExactState(state1)
	exact2 = toExactState(state2)
	return exact1 ≈ exact2
end

siteForQubit(state::MPSState, i::Int) = siteForQubit(state.map,i)
sitesForQubits(state::MPSState, inds::Vector{Int}) = sitesForQubits(state.map, inds)
qubitAtSite(state::MPSState, i::Int) = qubitAtSite(state.map, i)
qubitsAtSites(state::MPSState, inds::Vector{Int}) = qubitsAtSites(state.map, inds)

updateMap!(state::MPSState; kwargs...) = updateMap!(state.map; kwargs...)

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

# TODO: Contract in a binary tree order?
toExactState(state::MPSState) = ExactState(prod(state.sites))

function normalize!(state::MPSState; kwargs...)
	center::Int = get(kwargs, :center,-1)
	if center ==-1
		center = state.llim+1
	end
	centerAtSite!(state,center)
end
# apply!(state::MPSState, gate::MeasureGate) = collapseQubits!(state, qubits(gate); reset=reset(gate))
function measure!(state::MPSState, qubits::Vector{Int}, shots::Int; kwargs...)
	binary = get(kwargs, :binary, true)
	probability = get(kwargs, :probability, false)
	if length(qubits) > 1
		localizeQubitsInOrder!(state, qubits; kwargs...)
	end
	sites = sitesForQubits(state, qubits)
	centerAtSite!(state, sites[1])
	if !probability
		if binary
			results = zeros(Int, shots, length(qubits))
			for i = 1:shots
				results[i,:] = oneShot(state, sites; kwargs...)
			end
		else
			results = zeros(Int, shots)
			for i = 1:shots
				results[i] = oneShot(state, sites; kwargs...)
			end
		end
		return results
	else 
		prob = zeros(shots)
		if binary
			results = zeros(Int, shots, length(qubits))
			for i = 1:shots
				results[i,:], prob[i] = oneShot(state, sites; kwargs...)
			end
		else
			results = zeros(Int, shots)
			for i = 1:shots
				results[i], prob[i] = oneShot(state, sites; kwargs...)
			end
		end
		return results, prob
	end
end

function measure!(state::MPSState, qubit::Int, shots::Int; kwargs...)
	site = siteForQubit(state, qubit)
	centerAtSite!(state, site)
	results = zeros(Int, shots)
	for i = 1: shots
		results[i] = oneShot(state, [site]; kwargs...)[1]
	end
	return results
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
	sortedSites = sort!(sitesForQubits(state, actpos.qubits))

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
	state[s] /= norm(state[s]) # normalization
	return state
end

centerAtQubit!(state::MPSState, q::Int) = centerAtSite!(state, siteForQubit(state, q))



function swapSites!(state::MPSState, s1::Int, s2::Int, decomp= "svd"; kwargs...)
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
	updateMap!(state; s=s1, q=q2)
	updateMap!(state; s=s2, q=q1)
	state.llim >= s1 && (state.llim = s1-1)
	state.rlim <= s2 && (state.rlim = s2+1)
end

function projector(i::Int, ind::Index)
		data = zeros(2)
		data[i] = 1
		return ITensor(data, ind)
end

function oneShot(state::MPSState, sites::Vector{Int}; kwargs...)
	binary = get(kwargs, :binary, true)
	probability = get(kwargs, :probability, false)
	if binary 
		sample = zeros(Int, length(sites))
	else 
		sample = 0
	end
	prob = 1
	clamped = nothing

	for i =1:length(sites)
		ψ = state[sites[i]]
		clamped != nothing && (ψ *= clamped)
		ψ0 = ψ*projector(1, findindex(ψ, "Site"))
		prob0 = Real(scalar(ψ0 * dag(ψ0)))
		ψ1 = ψ*projector(2, findindex(ψ, "Site"))
		prob1 = Real(scalar(ψ1 * dag(ψ1)))
		total = (prob0+prob1)
		prob0 /= total
		prob1 /= total
		if rand(0:10000)/10000 > prob0
			if binary
				sample[i] = 1
			else
				sample += 2^(i-1)
			end
			clamped = ψ1
			prob *= prob1
		else
			clamped = ψ0
			prob *= prob0
		end

	end

	if probability
		return sample, prob
	else
		return sample
	end
end


function collapse!(state::MPSState, qubit::Int; kwargs...)
	reset = get(kwargs, :reset, false)
	site = siteForQubit(state, qubit)
	centerAtSite!(state, site)
	ψ = state[site]
	proj0 = projector(1, findindex(ψ, "Site"))
	ψ0 = ψ*proj0
	proj1 = projector(2, findindex(ψ, "Site"))
	ψ1 = ψ*proj1
	prob0 = Real(scalar(ψ0 * dag(ψ0)))
	prob1 = Real(scalar(ψ1 * dag(ψ1)))
	if rand(0:10000)/10000 < prob0
		result = 0
		state[site] = ψ1*proj0
	else
		result = 1
		if reset
			state[site] = ψ1*proj0
		else
			state[site] = ψ1*proj1
		end
	end
	updateLims!(state, site)
	return result
end

function collapse!(state::MPSState, qubits::Vector{Int}; kwargs...)
	results = zeros(Int, length(qubits))
	for i = 1:length(qubits)
		results[i] = collapse!(state, qubits[i]; kwargs...)
	end
	return results
end


function dag(state::MPSState)
	sites_dag = Vector{ITensor}(undef,0)
	for i =1:length(state)
		push!(sites_dag, dag(state[i]))
	end
	return MPSState(sites_dag, copy(state.map), 0, length(state)+1) # llim, rlim may be optimized
end

function ρ(state::MPSState, config::Vector{Int})
	if any(config .> 1) || any(config .<0)
		error("Invalid configuration input.")
	end
	clampedMPS = Vector{ITensor}(undef,0)
	for s = 1:length(config)
		q = qubitAtSite(state, s)
		siteindex = findindex(state[s], "Site")
		push!(clampedMPS, clamp(state[s], siteindex, config[q]+1))
	end
	return scalar(prod(clampedMPS))
end

function show(io::IO, state::MPSState)
	println(io, "$(length(state))-qubit MPSState")
end
function showStructure(io::IO, state::MPSState)
	printstyled(io, "MPSState\n"; bold=true, color=:red)
	for i =1: length(state)
		printstyled(io, "Site $(i):"; bold=true, color=43)
		print(io, IndexSet(state.sites[i]),"\n")
	end
	printstyled(io, "siteForQubit:"; bold=true, color=:blue)
	println(io, state.map.siteForQubit)
	printstyled(io, "qubitAtSite:"; bold=true, color=:blue)
	println(io, state.map.qubitAtSite)
	printstyled(io, "llim = $(state.llim), rlim = $(state.rlim)\n", bold=true, color=:blue)
end

function showData(io::IO,state::MPSState)
	printstyled("--- MPS state: ---\n"; bold=true, color=5)
	for i =1: length(state)
		printstyled(io, "Site $(i):\n"; bold=true, color=43)
		print(io, state[i],"\n")
	end
end
showData(state::MPSState) = showData(stdout, state)
