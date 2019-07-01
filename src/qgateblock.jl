
mutable struct QGateBlock
	gates::Vector{Union{QGate, QGateBlock}}
	qubits::Vector{ActPosition}
	QGateBlock() = new(Vector{Union{QGate, QGateBlock}}(undef, 0), ActPosition[])
	QGateBlock(gates::Vector{Union{QGate, QGateBlock}}, qubits::Vector{ActPosition}) = new(gates, qubits)
end # struct

const Operator = Union{QGate, QGateBlock}

gates(block::QGateBlock) = block.gates
qubits(block::QGateBlock) = block.qubits
size(block::QGateBlock) = size(block.gates)
iterate(block::QGateBlock, state::Int=1) = iterate(block.gates, state)
copy(block::QGateBlock) = QGateBlock(copy.(gates(block)), copy(qubits))
length(block::QGateBlock) = length(gates(block))

function addGate!(block::QGateBlock, gate::Operator, pos::ActPosition)
	push!(gates(block), gate)
	push!(qubits(block), pos)
end

const GatePosTuple = Tuple{T, ActPosition} where {T <: Operator}

function addGate!(block::QGateBlock, tuples::GatePosTuple...)
	for tuple ∈ tuples
		addGate!(block, tuple[1], tuple[2])
	end
end

function apply!(state::QState, block::QGateBlock, pos::ActPosition)
	for j = 1: length(block)
		gateOrBlock = gates(block)[j]
		gateOrBlockPos = qubits(block)[j]
		apply!(state, gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]))
	end
end

function flatten(block::QGateBlock, pos::ActPosition, flatttened = nothing)
	flatttened==nothing && (flatttened = QGateBlock())
	for i = 1:length(block)
		gateOrBlock = gates(block)[i]
		gateOrBlockPos = qubits(block)[i]
		if isa(gateOrBlock, QGateBlock)
			flatten(gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]),flatttened)
		else
			addGate!(flatttened, gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]))
		end
	end
	return flatttened
end

function show(io::IO, block::QGateBlock)
	for i = 1:length(block)
		if isa(block.gates[i], QGateBlock)
			printstyled(io, "BLOCK\n"; color = :red)
			print(io, block.qubits[i],"\n")
			print(io, block.gates[i])
		else
			print(io, block.gates[i]," , ", block.qubits[i], "\n")
		end
	end
end
