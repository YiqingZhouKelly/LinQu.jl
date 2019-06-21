
struct ConstGate
	id::Int
	qubits::Vector{Int}
	ConstGate(id::Int, qubits::Tuple{Vector{Int}}) = new(id, qubits[1])
	ConstGate(id::Int, qubits::NTuple{T, Int} where {T}) = new(id, [qubits...])
end #struct

qubits(gate::ConstGate) = gate.qubits
id(gate::ConstGate) = gate.id
data(gate::ConstGate) = GATE_TABLE[id(gate)]

X(qubits::Location...) = ConstGate(1, qubits) 
Y(qubits::Location...) = ConstGate(2, qubits) 
Z(qubits::Location...) = ConstGate(3, qubits) 
H(qubits::Location...) = ConstGate(4, qubits) 
S(qubits::Location...) = ConstGate(5, qubits) 
SDAG(qubits::Location...) = ConstGate(6, qubits) 
T(qubits::Location...) = ConstGate(7, qubits) 
TDAG(qubits::Location...) = ConstGate(8, qubits) 
SWAP(qubits::Location...) = ConstGate(9, qubits) 
CNOT(qubits::Location...) = ConstGate(10, qubits) 
TOFFOLI(qubits::Location...) = ConstGate(11, qubits) 
FREDKIN(qubits::Location...) = ConstGate(12, qubits) 

function ITensor(gate::ConstGate, inds::IndexSet)
	print(data(gate))
	return ITensor(data(gate), inds)
end
ITensor(gate::ConstGate, ind::Index...) = ITensor(data(gate), ind...)