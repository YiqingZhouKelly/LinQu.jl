
const QGate = Union{VarGate, ConstGate}

function (+)(gate::QGate, offset::Int)
	gateCopy = copy(gate)
	gateCopy.qubits.+=offset
	return gateCopy
end