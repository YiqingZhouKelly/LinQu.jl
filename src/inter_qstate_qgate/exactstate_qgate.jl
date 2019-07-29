
function apply!(state::ExactState, gate::QGate, qubits::Vector{Int}; kwargs...)
	inds = IndexSet([findindex(state.site, "q=$(q)") for q ∈ qubits])
	gateITensor = ITensor(gate, IndexSet(prime(inds), inds))
	state.site = noprime(state.site * gateITensor)
	return state
end

apply!(state::ExactState, gate::QGate, qubit::Int; kwargs...) = apply!(state, gate, [qubit]; kwargs...)