
mutable struct QGateBlock
	gates::Vector{T} where {T<:QGate}
	offset::Int

	QGateBlock() = new(QGate[],-1)
	QGateBlock(gates::Vector{T}, offset::Int) where {T<: QGate} = new(gates, offset)
	function QGateBlock(gates::Vector{T}) where {T<:QGate}
		offset = qubits(gates[1])[1]
		gates.-= offset
		new(gates, offset)
	end
end

gates(block::QGateBlock) = block.gates
offset(block::QGateBlock) = block.offset
length(block::QGateBlock) = length(block.gates)
size(block::QGateBlock) = size(block.gates)
iterate(block::QGateBlock, state::Int=1) = iterate(block.gates,state)

function push!(block::QGateBlock, gate::QGate...)
	if length(block)==0
		block.offset = qubits(gate[1])[1]
	end
		push!(block.gates, (gate .- block.offset)...)
end

function applyGate!(state::QState, block::QGateBlock)
	for gate ∈ gates(block)
		applyGate!(state, gate + offset(gate))
	end
end

zeroOffset(block::QGateBlock) = QGateBlock(gates(block).+offset(block), 0)