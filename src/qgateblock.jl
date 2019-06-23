
mutable struct QGateBlock
	gates::Vector{QGate}
	offset::Int

	QGateBlock() = new()
	QGateBlock(gates::Vector{QGate}, offset::Int) = new(gates, offset)
	function QGateBlock(gates::Vector{QGate})
		offset = qubits(gates[1])[1]
		gates.-= offset
		new(gates, offset)
	end
end

gates(block::QGateBlock) = block.gates
offset(block::QGateBlock) = block.offset
length(block::QGateBlock) = length(block.gates)

# TODO : iterator
function push!(block::QGateBlock, gate::QGate)
	if length(block)==0
		block.offset = qubits(gate)[1]
	end
		push!(block.gates, gate - block.offset)
end

function applyGate!(state::QState, block::QGateBlock)
	for gate ∈ gates(block)
		applyGate!(state, gate+offset)
	end
end

zeroOffset(block::QGateBlock) = QGateBlock(gates(block).+offset(block), 0)