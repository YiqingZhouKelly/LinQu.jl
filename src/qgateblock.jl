
mutable struct QGateBlock
	gates::Vector{Union{QGate, QGateBlock}}
	qubits::Vector{ActPosition}
	QGateBlock() = new(Vector{Union{QGate, QGateBlock}}(undef, 0), ActPosition[])
	QGateBlock(gates::Vector{Union{QGate, QGateBlock}}, qubits::Vector{ActPosition}) = new(gates, qubits)
end # struct

const Operator = Union{QGate, QGateBlock}

gates(block::QGateBlock) = block.gates
qubits(block::QGateBlock) = block.qubits

copy(block::QGateBlock) = QGateBlock(copy.(gates(block)), copy(qubits))
function addGate!(block::QGateBlock, gate::QGate, pos::ActPosition)
	push!(gates(block), gate)
	push!(qubits(block), pos)
end

const GatePosTuple = Tuple{T, ActPosition} where {T <: QGate}

function addGate!(block::QGateBlock, tuples::GatePosTuple...)
	for tuple ∈ tuples
		addGate!(block, tuple[1], tuple[2])
	end
end
length(block::QGateBlock) = length(gates(block))
size(block::QGateBlock) = size(block.gates)
iterate(block::QGateBlock, itstate::Int=1) = iterate(block.gates,itstate)

function apply!(state::QState, block::QGateBlock, pos::ActPosition)
	for j = 1: length(block)
		gateOrBlock = gates(block)[j]
		gateOrBlockPos = qubits(block)[j]
		apply!(state, gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]))
	end
end