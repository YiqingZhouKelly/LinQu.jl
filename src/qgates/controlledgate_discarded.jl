
const freeGate = Union{ConstGate, CustomizedGate}
struct ControlledGate
	targetGate::freeGate
	qubits::Vector{Int}
	ControlledGate(gate::freeGate, qubits::Vector{Int}) = new(gate, qubits)
	ControlledGate(gate::freeGate, controlbit::Int) = new(gate, [controlbit, qubits(gate)...])
end #struct

qubits(gate::ControlledGate) = gate.qubits
targetGate(gate::ControlledGate) = gate.targetGate
copy(gate::ControlledGate) = ControlledGate(targetGate, copy(quibits))

function data(gate::ControlledGate)
	length(qubits(gate))!=2 && error("Currently only support controlled sigle qubit gate\n")
	dataTensor = zeros(ComplexF64,2,2,2,2)
	dataTensor[1,:,1,:] = diagm(0=>ones(ComplexF64, 2))
	dataTensor[2,:,2,:] = data(targetGate(gate))
	return dataTensor
end
