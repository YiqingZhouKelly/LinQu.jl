mutable struct CustomizedGate
	f::Function
	param:: Vector{T} where {T <: Number}
	qubits::Vector{Int}
	name::String
	CustomizedGate(f::Function, 
				   param:: Vector{T} where {T <: Number},
				   qubits::Vector{Int}, 
				   name="CustomizedGate") = new(f, param, qubits, name)
	CustomizedGate(f::Function, 
				   param:: Vector{T} where {T <: Number},
				   qubits::NTuple{S, Int} where {S}, 
				   name="CustomizedGate") = new(f, param, [qubits...], name)

end # struct

qubits(gate::CustomizedGate) = gate.qubits
param(gate::CustomizedGate) = gate.param
func(gate::CustomizedGate) = gate.f
name(gate::CustomizedGate) = gate.name

copy(gate::CustomizedGate) = CustomizedGate(gate.f, copy(gate.param), copy(gate.qubits))
changeParam!(gate::CustomizedGate, newParam::Vector{Number}) = (gate.param = newParam; return gate)
changeParam(gate::CustomizedGate, newParam::Vector{Number}) = CustomizedGate(gate.f, newParam, copy(qubits))

data(gate::CustomizedGate) = gate.f((gate.param)...)

RxFunc(θ::Number) = cos(θ/2)I_DATA - sin(θ/2)im* X_DATA
RyFunc(θ::Number) = cos(θ/2)I_DATA - sin(θ/2)im* Y_DATA
RzFunc(θ::Number) = cos(θ/2)I_DATA - sin(θ/2)im* Z_DATA

function RϕFunc(θ::Number)
	phaseGate = zeros(ComplexF64,2,2)
	phaseGate[1,1] = 1
	phaseGate[2,2] = exp(θ* 1im)
	return phaseGate
end

Rx(θ::Number, qubits::Location...) = CustomizedGate(RxFunc, [θ], qubits, "Rx")
Ry(θ::Number, qubits::Location...) = CustomizedGate(RyFunc, [θ], qubits, "Ry")
Rz(θ::Number, qubits::Location...) = CustomizedGate(RzFunc, [θ], qubits, "Rz")
Rϕ(θ::Number, qubits::Location...) = CustomizedGate(RϕFunc, [θ], qubits, "Rϕ")

function show(io::IO,gate::CustomizedGate)
	print("$(name(gate)), $(param(gate)) ,  $(qubits(gate))\n")
end