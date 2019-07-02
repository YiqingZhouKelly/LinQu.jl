
mutable struct QGateBlock
	gates::Vector{Union{QGate, QGateBlock}}
	qubits::Vector{ActPosition}
	QGateBlock() = new(Vector{T where {T<:Union{QGate,QGateBlock}}}(undef, 0), ActPosition[])
	QGateBlock(gates::Vector{T} where {T<:Union{QGate,QGateBlock}}, qubits::Vector{ActPosition}) = new(gates, qubits)
end # struct

const Operator = Union{QGate, QGateBlock}

gates(block::QGateBlock) = block.gates
qubits(block::QGateBlock) = block.qubits
size(block::QGateBlock) = size(block.gates)
iterate(block::QGateBlock, state::Int=1) = iterate(block.gates, state)
copy(block::QGateBlock) = QGateBlock(copy.(gates(block)), copy(qubits(block)))
length(block::QGateBlock) = length(gates(block))
function ==(block1::QGateBlock, block2::QGateBlock)
	length(block1)!=length(block2) && (return false)
	for i =1:length(block1)
		if (block1.gates[i]!= block2.gates[i]) || (block1.qubits[i]!= block2.qubits[i])
			return false
		end
	end
	return true
end
function add!(block::QGateBlock, gate::Operator, pos::ActPosition)
	push!(gates(block), gate)
	push!(qubits(block), pos)
	return block
end

const GatePosTuple = Tuple{T, ActPosition} where {T <: Operator}

function add!(block::QGateBlock, tuples::GatePosTuple...)
	for tuple ∈ tuples
		add!(block, tuple[1], tuple[2])
	end
	return block
end

addCopy!(block::QGateBlock, gate::Operator, pos::ActPosition) = add!(block, copy(gate), pos)
function addCopy!(block::QGateBlock, tuples::GatePosTuple...)
	for tuple ∈ tuples
		add!(block, copy(tuple[1]), copy(tuple[2]))
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
			add!(flatttened, gateOrBlock, ActPosition([pos[i] for i ∈ gateOrBlockPos]))
		end
	end
	return flatttened
end

function extractParams(block::QGateBlock, params= nothing)
	params==nothing && (params= Real[])
	for gateOrBlock ∈ block 
		if isa(gateOrBlock, QGateBlock)
			extractParams(gateOrBlock, params)
		elseif isa(gateOrBlock, VarGate)
			push!(params, param(gateOrBlock)...)
		end
	end
	return params
end

function insertParams!(block::QGateBlock, params::Vector{T} where {T<:Real}, i::Int = 1)
	for gateOrBlock ∈ block
		if isa(gateOrBlock, QGateBlock)
			i = insertParams!(gateOrBlock, params, i)
		elseif isa(gateOrBlock, VarGate)
			n = paramCount(gateOrBlock)
			setParam!(gateOrBlock, params[i:i+n-1])
			i+=n
		end
	end
	return i
end

function inverse(block::QGateBlock)
	inversed = QGateBlock()
	reverseOrderGates = reverse(block.gates)
	reverseOrderPos = reverse(block.qubits)
	for i = 1:length(block)
		add!(inversed, inverse(reverseOrderGates[i]), reverseOrderPos[i])
	end
	return inversed
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
