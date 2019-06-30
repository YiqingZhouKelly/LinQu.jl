
mutable struct ConstGate <: QGate
	kernel::GateKernel
	ConstGate(kernel::GateKernel) = new(kernel)
end #struct

name(gate::ConstGate) = name(gate.kernel)
data(gate::ConstGate) = func(gate)()
func(gate::ConstGate) = func(gate.kernel)

(gate::ConstGate)(qubit::Int...) = (gate, ActPosition([qubit...]))

function control(gate::ConstGate)
	function controlFunc()
		controlled = zeros(ComplexF64,2,2,2,2)
		controlled[1,:,1,:] = diagm(0=>ones(ComplexF64, 2))
		controlled[2,:,2,:] = data(gate)
		return controlled
	end
	kernel = GateKernel(controlFunc, "Control-"*name(gate))
	return ConstGate(kernel)
end

function show(io::IO, gate::ConstGate)
	printstyled(io, name(gate); bold=true, color= :blue)
end
