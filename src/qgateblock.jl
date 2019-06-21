
mutable struct QGateBlock
	gates::Vector{QGate}
	offset::Int

end
gates(block::QGateBlock) = block.gates

function applyGate!(state::QState, block::QGateBlock)
	for gate ∈ gates(block)
		applyGate!(state, gate+offset)
	end
end