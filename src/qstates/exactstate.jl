
mutable struct ExactState
	site:: ITensor
	ExactState(T::ITensor) = new(T)
	function ExactState(N::Int, init::Vector{T}) where T
		norm(init) != 1 && error("initial state must have norm 1\n")
		net = ITensorNet()
		for i =1: N
			push!(net, ITensor(init, Index(2,"Site, q=$(i)")))
		end
		new(contractall(net))
	end
	ExactState(N::Int) = ExactState(N, [1,0])
end #struct

function applyGate!(state::ExactState, gate::QGate)
	qubitInds = qubits(gate)
	inds = IndexSet([findindex(state.site, "q=$(q)") for q ∈ qubitInds])
	gateITensor = ITensor(data(gate), IndexSet(inds, prime(inds)))
	state.site = noprime(state.site * gateITensor)
	return state
end

function toMPSState(state::ExactState; kwargs...)
	numQubits = length(IndexSet(state.site))
	leftLink = nothing
	remain = copy(state.site) 
	sites = ITensor[]
	for i =1:numQubits-1
		if leftLink != nothing
			U,S,V,leftLink,v = svd(remain, 
								   IndexSet(leftLink, findindex(remain, "q=$(i)")); 
								   kwargs...)
		else
			U,S,V,leftLink,v = svd(remain, findindex(remain, "q=$(i)"); kwargs...)
		end
		push!(sites, replacetags(U, "u", "l=$(i)"))
		S = replacetags(S, "u", "l=$(i)")
		leftLink = replacetags(leftLink, "u", "l=$(i)")
		remain = S*V
	end
	push!(sites, remain)
	return MPSState(sites,QubitSiteMap(numQubits), numQubits-1, numQubits+1)
end