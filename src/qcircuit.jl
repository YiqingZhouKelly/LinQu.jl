
mutable struct QCircuit
	operators:: Vector{T} where {T<:Operator}
	QCircuit() = new(Operator[])
	QCircuit(gates::Vector{T}) where {T<:Operator} = new(gates)

end #struct

operators(circuit::QCircuit) = circuit.operators
push!(circuit::QCircuit, gate::Operator...) = push!(circuit.operators, gate...)

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
			push!(block, (gates(operator).+offset(operator))...)
		else
			push!(block, operator)
		end
	end
	return block
end

function applyCircuit!(state::QState, circuit::QCircuit; kwargs...)
	for op ∈ circuit.operators
		applyGate!(state, op; kwargs...)
	end
	return state
end
