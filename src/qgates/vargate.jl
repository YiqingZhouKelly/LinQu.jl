
mutable struct VarGate <: QGate
	kernel::GateKernel
	param:: Vector{T} where {T<:Real}
	VarGate(kernel::GateKernel, param::Vector{T} where {T<:Real}) = new(kernel, param)
	VarGate(kernel::GateKernel) = new(kernel, zeros(paramCount(kernel)))
end # struct

name(gate::VarGate) = name(gate.kernel)
param(gate::VarGate) = gate.param
paramCount(gate::VarGate) = paramCount(gate.kernel)
copy(gate::VarGate) = VarGate(gate.kernel, copy(gate.param))
data(gate::VarGate) = func(gate)(param(gate)...)
func(gate::VarGate) = func(gate.kernel)
setParam!(gate::VarGate, newParams::Vector{T} where {T<: Real}) = (gate.param = newParams)

control(gate::VarGate) = VarGate(control(gate.kernel), copy(gate.param))
==(gate1::VarGate, gate2::VarGate)= (gate1.kernel==gate2.kernel && gate1.param ==gate2.param)

function show(io::IO,gate::VarGate)
	printstyled(io, name(gate); bold=true, color= :blue)
	print(", $(param(gate))\n")
end