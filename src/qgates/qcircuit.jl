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

add!(circuit::QCircuit, operator::Operator, pos::ActPosition) = (add!(circuit.block, operator, pos); return circuit)
add!(circuit::QCircuit, tuples::GatePosTuple...) = (add!(circuit.block, tuples...); return circuit)
addCopy!(circuit::QCircuit, operator::Operator, pos::ActPosition) = (addCopy!(circuit.block, operator, pos); return circuit)
addCopy!(circuit::QCircuit, tuples::GatePosTuple...) = (addCopy!(circuit.block, tuples...); return circuit)

function flatten(circuit::QCircuit, flattened=nothing) 
	flattened = flatten(circuit.block, ActPosition([1:circuit.N;]), flattened)
	return QCircuit(flattened, circuit.N)
end
inverse(circuit::QCircuit) = QCircuit(inverse(circuit.block), circuit.N)
randomQCircuit(size::Int, depth::Int = rand(1:10)) = QCircuit(randomQGateBlock(size,depth), size)

function show(io::IO, circuit::QCircuit)
	printstyled(io, "Circuit\n"; bold=true, color = 9)
	print(io, circuit.block)
end

#TODO: add insert/extract param functions for circuits
