
mutable struct MPSState
	sites::Vector{ITensor}
	siteForQubit::Vector{Int}
	qubitAtSite::Vector{Int}
	llim::Int
	rlim::Int
	MPSState(sites::Vector{ITensor},
		     siteForQubit::Vector{Int},
		     qubitAtSite::Vector{Int},
		     llim::Int,
		     rlim::Int) = new(sites, siteForQubit,qubitAtSite, llim, rlim)

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
		new(sites,[1:1:N;],[1:1:N;],0,N+1)
	end
	MPSState(N::Int) = MPSState(N, [1,0])
end #struct
getindex(state::MPSState, n::Int) = getindex(state.sites,n)
setindex!(state::MPSState, T::ITensor, n::Integer) = setindex!(state.sites, T, n)
length(state::MPSState) = length(state.sites)
size(state::MPSState) = size(state.sites)
iterate(state::MPSState, itstate::Int=1) = iterate(state.sites,itstate)

siteForQubit(state::MPSState, i::Int) = state.siteForQubit[i]
sitesForQubits(state::MPSState, inds::Vector{Int}) = [siteForQubit(state,i) for i ∈ inds]
qubitAtSite(state::MPSState, i::Int) = state.qubitAtSite[i]
qubitsAtSites(state::MPSState, inds::Vector{Int}) = [qubitAtSite(state,i) for i ∈ inds]
getQubit(state::MPSState, i::Int) = state.sites[siteForQubit(state,i)]
getQubits(state::MPSState, inds::Vector{Int}) = [getQubit(state, i) for i ∈ inds]
siteIndex(state::MPSState, i::Int) = findindex(state[i], "Site")
siteInds(state::MPSState, inds::Vector{Int}) = IndexSet([siteIndex(state, i) for i ∈ inds])

function applyGate!(state::MPSState, gate::QGate; kwargs...)
	localizeQubits!(state, qubits(gate); kwargs...)
	centerAtQubit!(state, qubits(gate)[1])
	applyLocalGate!(state, gate; kwargs...)
end

function getProbDist(state::MPSState, qubits::Vector{Int}; kwargs...)
	localizeQubits!(state, qubits; kwargs...)
	centerAtQubit!(state, qubits[1])
	qubitITensors = getQubits(state, qubits)
	psi = prod(qubitITensors)
	linkinds = findinds(psi, "Link")
	probDensity = psi * dag(noprime(psi', linkinds'))
	return probDensity
end

toExactState(state::MPSState) = ExactState(prod(state.sites))

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

function localizeQubits!(state::MPSState, qubits::Vector{Int}; kwargs...)
	sortedSites = sort(sitesForQubits(state, qubits))

	for i = 2: length(sortedSites)
		moveSite!(state, sortedSites[i], sortedSites[i-1]+1; kwargs...)
		sortedSites[i] = sortedSites[i-1]+1
	end
	
	return state
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

function applyLocalGate!(state::MPSState, gate::QGate; kwargs...)
	# Contract
	sites = sitesForQubits(state, qubits(gate))
	inds = siteInds(state, sites)
	gateITensor = ITensor(data(gate), IndexSet(inds, prime(inds)))
	qubitITensors = getQubits(state, qubits(gate))
	product = noprime(gateITensor * prod(qubitITensors))

	# SVD Split
	newSites = ITensor[]
	linkindex = leftEnd = min(sites...)
	leftEnd >1 ? leftLink=findindex(product, "l=$(leftEnd-1)") : leftLink=Nothing
	for i =1:length(sites)-1
		if leftLink != Nothing 
			U,S,V,leftLink,v = svd(product, 
							IndexSet(leftLink, findindex(product, "q=$(qubits(gate)[i])"));
							kwargs...)
		else
			U,S,V,leftLink,v = svd(product, 
							findindex(product, "q=$(qubits(gate)[i])");
							kwargs...)
		end
		leftLink = replacetags(leftLink, "u", "l=$(linkindex)")
		U = replacetags(U, "u", "l=$(linkindex)")
		S = replacetags(S, "u", "l=$(linkindex)")
		product = S*V
		push!(newSites, U)
		linkindex+=1
	end
	push!(newSites, product)

	# update state
	for i =1:length(sites)
		state.sites[leftEnd-1+i] = newSites[i]
		state.qubitAtSite[leftEnd-1+i] = qubits(gate)[i]
		state.siteForQubit[qubits(gate)[i]] = leftEnd-1+i
	end
	rightEnd = leftEnd-1+length(sites)
	state.llim >= leftEnd && (state.llim = leftEnd-1)
	state.rlim <= rightEnd && (state.rlim = rightEnd+1)
	return state
end

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
	state.qubitAtSite[s1] = q2
	state.qubitAtSite[s2] = q1
	state.siteForQubit[q1] = s2
	state.siteForQubit[q2] = s1
	state.llim >= s1 && (state.llim = s1-1)
	state.rlim <= s2 && (state.rlim = s2+1)
end

function show(io::IO, state::MPSState)
	for i =1: length(state)
		print("Site $(i):", IndexSet(state.sites[i]),"\n")
	end
	print("siteForQubit:", state.siteForQubit, "\n")
	print("qubitAtSite:", state.qubitAtSite, "\n")
	print("llim = $(state.llim), rlim = $(state.rlim)\n")
end

function printFull(state::MPSState)
	print(state.sites,"\n")
end
