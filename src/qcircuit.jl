struct QCircuit
	block::QGateBlock
	N::Int
	QCircuit(N::Int) = new(QGateBlock(), N)
	QCircuit(block::QGateBlock, N::Int) = new(block, N)
end # struct

gates(circuit::QCircuit) = gate(cirucit.block)
size(cirucit::QCircuit) = size(cirucit.block) 
iterate(circuit::QCircuit, state::Int = 1) = iterate(cirucit.block, state)
length(circuit::QCircuit) = length(circuit.block)

addGate!(circuit::QCircuit, operator::Operator, pos::ActPosition) = addGate!(circuit.block, operator, pos)
addGate!(circuit::QCircuit, tuples::GatePosTuple...) = addGate!(circuit.gate, tuples...)

apply!(state::QState, circuit::QCircuit, pos::ActPosition) = apply!(state, circuit.block, pos)

function flatten(circuit::QCircuit, flattened=nothing) 
	flattened = flatten(circuit.block, ActPosition([1:1:circuit.N;]), flattened)
	return QCircuit(flattened, circuit.N)
end

function show(io::IO, circuit::QCircuit)
	printstyled(io, "Circuit\n"; bold=true, color = 9)
	print(io, circuit.block)
end
