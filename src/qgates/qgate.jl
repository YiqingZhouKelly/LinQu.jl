
const QGate = Union{VarGate, ConstGate}

function QGate(id::Int, qubits::Location...)
	if id <= CONST_GATE_COUNT
		return ConstGate(id, qubits)
	else
		return VarGate(id%CONST_GATE_COUNT, qubits)
	end
end

function (+)(gate::QGate, offset::Int)
	gateCopy = copy(gate)
	gateCopy.qubits.+=offset
	return gateCopy
end

(-)(gate::QGate, offset::Int) = (+)(gate, -offset)