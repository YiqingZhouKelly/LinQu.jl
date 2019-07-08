
function apply!(state::QState, block::QGateBlock, pos::ActPosition; kwargs...)
	for j = 1: length(block)
		gateOrBlock = gates(block)[j]
		gateOrBlockPos = qubits(block)[j]
		apply!(state, gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]); kwargs...)
	end
end

apply!(state::QState, circuit::QCircuit; kwargs...) = apply!(state, circuit.block, ActPosition([1:1:circuit.N;]); kwargs...)
