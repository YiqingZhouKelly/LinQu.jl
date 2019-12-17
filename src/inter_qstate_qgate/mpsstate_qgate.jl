function apply!(state::MPSState, gate::QGate, qubits::Vector{Int}; kwargs...)
	if length(qubits)>1
		localizeQubits!(state, qubits; kwargs...)
		qrswitch::Bool = get(kwargs, :qrswitch, true)
		qrswitch && (centerAtQubit!(state, qubits[1]))
		applyLocalGate!(state, gate, qubits; kwargs...)
	else
		applyLocalGate!(state, gate, qubits)
	end
end

apply!(state::MPSState, gate::QGate, qubit::Int; kwargs...) = applyLocalGate!(state, gate, qubit)

function applyLocalGate!(state::MPSState, gate::QGate, actpos::Vector{Int}; kwargs...)
	# Contract
	sites = sitesForQubits(state, actpos)
	inds = siteInds(state, sites)
	gateITensor = ITensor(gate, IndexSet(prime(inds), inds))
	qubitITensors = getQubits(state, actpos)
	product = noprime(gateITensor * prod(qubitITensors))

	# SVD Split
	newSites = ITensor[]
	linkindex = min(sites...)
	leftEnd = linkindex
	leftEnd >1 ? leftLink=findindex(product, "l=$(leftEnd-1)") : leftLink=nothing
	for i =1:length(sites)-1
		if leftLink != nothing
			U,S,V,spec,leftLink,v = svd(product,
							IndexSet(leftLink, findindex(product, "q=$(actpos[i])"));
							kwargs...)
		else
			U,S,V,spec, leftLink,v = svd(product,
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
		updateMap!(state; s=leftEnd-1+i, q=actpos[i])
	end
	rightEnd = leftEnd-1+length(sites)
	state.llim >= leftEnd-1 && (state.llim = rightEnd-1)
	state.rlim <= rightEnd+1 && (state.rlim = rightEnd+1)
	return state
end

applyLocalGate!(state::MPSState, gate::QGate, actpos::Int; kwargs...) = applyLocalGate!(state, gate, [actpos])

function measure!(state::MPSState, basis::QGateBlock, qubit::Int, shots::Int; kwargs...)
	apply!(state, basis, qubit)
	result = measure!(state, qubit, shots; kwargs...)
	inverseBasis = inverse(basis)
	apply!(state, inverseBasis, qubit)
	return result
end
function measure!(state::MPSState, basis::QGateBlock, actpos::Vector{Int}, shots::Int; kwargs...)
	for q ∈ actpos
		apply!(state, basis, q)
	end
	result = measure!(state, actpos, shots; kwargs...)
	inverseBasis = inverse(basis)
	for q ∈ actpos
		apply!(state, inverseBasis, q)
	end
	return result
end

function collapse!(state::MPSState, basis::QGateBlock, qubit::Int; reset = false)
	apply!(state, basis, qubit)
	return collapse!(state, qubit; reset = reset)
end

function collapse!(state::MPSState, basis::QGateBlock, qubits::Vector{Int}; reset = false)
	results = zeros(Int, length(qubits))
	for i =1:length(qubits)
		results[i] = collapse!(state, basis, qubits[i]; reset = reset)
	end
	return results
end
