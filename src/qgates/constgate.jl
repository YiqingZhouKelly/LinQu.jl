
mutable struct ConstGate <: QGate
	kernel::GateKernel
	ConstGate(kernel::GateKernel) = new(kernel)
end #struct

name(gate::ConstGate) = name(gate.kernel)
data(gate::ConstGate) = func(gate)()
func(gate::ConstGate) = func(gate.kernel)

copy(gate::ConstGate) = gate
==(gate1::ConstGate, gate2::ConstGate) = (gate1.kernel == gate2.kernel)
control(gate::ConstGate) = ConstGate(control(gate.kernel))

function show(io::IO, gate::ConstGate)
	printstyled(io, name(gate); bold=true, color= :blue)
end

inverse(gate::ConstGate) = ConstGate(inverse(gate.kernel))