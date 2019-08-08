struct QCircuit
	block::QGateBlock
	N::Int
	QCircuit(N::Int) = new(QGateBlock(), N)
	QCircuit(block::QGateBlock, N::Int) = new(block, N)
end # struct

gates(circuit::QCircuit) = gate(circuit.block)
size(circuit::QCircuit) = size(circuit.block)
iterate(circuit::QCircuit, state::Int = 1) = iterate(circuit.block, state)
length(circuit::QCircuit) = length(circuit.block)
==(circuit1::QCircuit, circuit2::QCircuit) = ((circuit1.block == circuit2.block) && (circuit1.N == circuit2.N))

add!(circuit::QCircuit, operator::Operator, pos::Vector{Int}) = (add!(circuit.block, operator, pos); return circuit)
add!(circuit::QCircuit, operator::Operator, qubits::Int...) = (add!(circuit.block,operator, [qubits...]); return circuit)
add!(circuit::QCircuit, tuples::GatePosTuple...) = (add!(circuit.block, tuples...); return circuit)
addCopy!(circuit::QCircuit, operator::Operator, pos::Vector{Int}) = (addCopy!(circuit.block, operator, pos); return circuit)
addCopy!(circuit::QCircuit, tuples::GatePosTuple...) = (addCopy!(circuit.block, tuples...); return circuit)

function flatten(circuit::QCircuit, flattened=nothing)
	flattened = flatten(circuit.block, [1:circuit.N;], flattened)
	return QCircuit(flattened, circuit.N)
end
inverse(circuit::QCircuit) = QCircuit(inverse(circuit.block), circuit.N)
randomQCircuit(size::Int, depth::Int = rand(1:10)) = QCircuit(randomQGateBlock(size,depth), size)

function showDetail(io::IO, circuit::QCircuit)
	printstyled(io, "Circuit\n"; bold=true, color = 9)
	print(io, circuit.block)
end

function show(io::IO, circuit::QCircuit)
	print(io, "$(circuit.N) qubit circuit")
end
