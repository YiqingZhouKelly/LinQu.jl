
const Operator = Union{QGate, QGateBlock}
mutable struct QCircuit
	operators:: Vector{Operator}
	QCircuit() = new(Operator[])
	QCircuit(gates::Vector{Operator}) = new(gates)

end #struct

operators(circuit::QCircuit) = circuit.operators
push!(circuit::QCircuit, gate::QGate) = push!(circuit.operators, gate)

function QCircuit(path::String)
	circuit = QCircuit()
	open(path) do file
		for line in eachline(file)
			parsed = split(line)
			gateId = findfirst(x->x==parsed[1], GATE_NAME)
			qubits = parse.(Int, parsed[2:end])
			push!(circuit, QGate(gateId, qubits))
		end
	end
	return circuit
end

function QGateBlock(circuit::QCircuit)
	block = QGateBlock()
	for operator ∈ operators(circuit)
		if isa(operator, QGateBlock)
			for gate ∈ operator 
				push!(block, gate+offset)
			end
		else
			push!(block, operator)
		end
	end
	return block
end

function runCircuit!(state::QState, circuit::QCircuit)
	for op ∈ circuit.gates
		applyGate!(state, op)
	end
end
