
function apply!(state::QState, block::QGateBlock, pos::Vector{Int}; kwargs...)
	for j = 1: length(block)
		gateOrBlock = gates(block)[j]
		gateOrBlockPos = qubits(block)[j]
		apply!(state, gateOrBlock, [pos[i] for i ∈ gateOrBlockPos]; kwargs...)
	end
end
apply!(state::QState, block::QGateBlock, pos::Int; kwargs...) = apply!(state, block, [pos]; kwargs...)

apply!(state::QState, circuit::QCircuit, pos::Vector{Int} = [1:circuit.N;]; kwargs...) = apply!(state, circuit.block, pos; kwargs...)