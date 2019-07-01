
function apply!(state::QState, block::QGateBlock, pos::ActPosition)
	for j = 1: length(block)
		gateOrBlock = gates(block)[j]
		gateOrBlockPos = qubits(block)[j]
		apply!(state, gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]))
	end
end

apply!(state::QState, circuit::QCircuit) = apply!(state, circuit.block, ActPosition([1:1:circuit.N;]))
