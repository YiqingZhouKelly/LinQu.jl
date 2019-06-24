mutable struct CustomizedGate
	f::Function
	param:: Vector{T} where {T <: Number}
	qubits::Vector{Int}
	CustomizedGate(f::Function, 
				   param:: Vector{T} where {T <: Number},
				   qubits::Vector{Int}) = new(f, param, qubits)
end # struct

qubits(gate::CustomizedGate) = gate.qubits
param(gate::CustomizedGate) = gate.param
func(gate::CustomizedGate) = gate.f

copy(gate::CustomizedGate) = CustomizedGate(gate.f, copy(gate.param), copy(gate.qubits))
changeParam!(gate::CustomizedGate, newParam::Vector{Number}) = (gate.param = newParam; return gate)
changeParam(gate::CustomizedGate, newParam::Vector{Number}) = CustomizedGate(gate.f, newParam, copy(qubits))

data(gate::CustomizedGate) = gate.f((gate.param)...)


function show(io::IO,gate::CustomizedGate)
	print("CustomizedGate, parameter = $(param(gate)), $(qubits(gate))\n")
end