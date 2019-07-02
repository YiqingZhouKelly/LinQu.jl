
function apply!(state::MPSState, gate::QGate, qubits::ActPosition; kwargs...)
	localizeQubits!(state, qubits; kwargs...)
	centerAtQubit!(state, qubits[1])
	applyLocalGate!(state, gate, qubits; kwargs...)
end

function applyLocalGate!(state::MPSState, gate::QGate, actpos::ActPosition; kwargs...)
	# Contract
	sites = sitesForQubits(state, actpos.qubits)
	inds = siteInds(state, sites)
	gateITensor = ITensor(gate, IndexSet(inds, prime(inds)))
	qubitITensors = getQubits(state, actpos.qubits)
	product = noprime(gateITensor * prod(qubitITensors))

	# SVD Split
	newSites = ITensor[]
	linkindex = leftEnd = min(sites...)
	leftEnd >1 ? leftLink=findindex(product, "l=$(leftEnd-1)") : leftLink=nothing
	for i =1:length(sites)-1
		if leftLink != nothing 
			U,S,V,leftLink,v = svd(product, 
							IndexSet(leftLink, findindex(product, "q=$(actpos[i])"));
							kwargs...)
		else
			U,S,V,leftLink,v = svd(product, 
							findindex(product, "q=$(actpos[i])");
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
		updateMap!(state, (s=leftEnd-1+i, q=actpos[i]))
	end
	rightEnd = leftEnd-1+length(sites)
	state.llim >= leftEnd && (state.llim = leftEnd-1)
	state.rlim <= rightEnd && (state.rlim = rightEnd+1)
	return state
end

function measure!(state::MPSState, basis::QGateBlock, actpos::ActPosition, shots::Int; kwargs...)
	for q ∈ actpos
		apply!(state, basis, ActPosition(q))
	end
	result = measure!(state, qubits(actpos), shots; kwargs...)
	inverseBasis = inverse(basis)
	for q ∈ actpos
		apply!(state, inverseBasis, ActPosition(q))
	end
	return result
end