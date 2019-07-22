
mutable struct VarGate <: QGate
	kernel::GateKernel
	param:: Vector
	VarGate(kernel::GateKernel, param::Vector) = new(kernel, param)
	VarGate(kernel::GateKernel) = new(kernel, zeros(paramCount(kernel)))
end # struct

VarGate(f::Function, paramCount::Int, name::String="Anonymous") = VarGate(GateKernel(f, paramCount,name))
VarGate(f::Function, param::Vector, name::String = "Anonymous") = VarGate(GateKernel(f, length(param), name), param)

name(gate::VarGate) = name(gate.kernel)
param(gate::VarGate) = gate.param
paramCount(gate::VarGate) = paramCount(gate.kernel)
copy(gate::VarGate) = VarGate(gate.kernel, copy(gate.param))
data(gate::VarGate) = func(gate)(param(gate)...)
func(gate::VarGate) = func(gate.kernel)
setParam!(gate::VarGate, newParams::Vector) = (gate.param = newParams)

control(gate::VarGate) = VarGate(control(gate.kernel), copy(gate.param))
==(gate1::VarGate, gate2::VarGate)= (gate1.kernel==gate2.kernel && gate1.param ==gate2.param)
inverse(gate::VarGate) = VarGate(inverse(gate.kernel), copy(gate.param))
function randomVarGate()
	choices = [Rx, Ry, Rz, Rϕ]
	param = 2π/rand(1:360)
	return VarGate(choices[rand(1:length(choices))], [param])
end

function show(io::IO,gate::VarGate)
	printstyled(io, name(gate); bold=true, color= :blue)
	print(io,", $(param(gate))\n")
end