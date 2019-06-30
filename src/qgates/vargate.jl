
mutable struct VarGate <: QGate
	kernel::GateKernel
	param:: Vector{T} where {T<:Real}
	VarGate(kernel::GateKernel, 
				   param::Vector{T} where {T<:Real}) = new(kernel, qubits, param)
end # struct

name(gate::VarGate) = name(gate.kernel)
param(gate::VarGate) = gate.param
copy(gate::VarGate) = VarGate(gate.kernel, copy(gate.param))
data(gate::VarGate) = func(gate)(param(gate)...)
func(gate::VarGate) = func(gate.kernel)
(gate::VarGate)(qubit::Int...) = (gate, ActPosition([qubit...]))


function control(gate::VarGate, controlbit::Int)
	# TODO: Suppport controlled multi-qubit gates?
	function controlFunc(p::Real...)
		controlled = zeros(ComplexF64,2,2,2,2)
		controlled[1,:,1,:] = diagm(0=>ones(ComplexF64, 2))
		controlled[2,:,2,:] = func(gate)(p...)
		return controlled
	end
	kernel = GateKernel(controlFunc, "Control-"*name(gate))
	return VarGate(kernel, copy(param))
end

function show(io::IO,gate::VarGate)
	printstyled(io, name(gate); bold=true, color= :blue)
	print(", $(param(gate))\n")
end