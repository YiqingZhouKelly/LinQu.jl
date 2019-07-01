
function apply!(state::ExactState, gate::QGate, qubits::ActPosition; kwarg...)
	inds = IndexSet([findindex(state.site, "q=$(q)") for q ∈ qubits])
	gateITensor = ITensor(gate, IndexSet(inds, prime(inds)))
	state.site = noprime(state.site * gateITensor)
	return state
end