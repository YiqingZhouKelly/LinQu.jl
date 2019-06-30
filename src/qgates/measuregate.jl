struct MeasureGate <:QGate
	qubits::Vector{Int}
	reset:: Bool
	MeasureGate(qubits::Vector{Int}, reset = false) = new(qubits, reset)
end

name(gate::MeasureGate) = "MEASURE"
qubits(gate::MeasureGate) = gate.qubits
reset(gate::MeasureGate) = gate.reset
copy(gate::MeasureGate) = MeasureGate(copy(gate.qubits), gate.reset)

MEASURE_RESET(qubits::Vector{Int}) = MeasureGate(qubits, true)
MEASURE(qubits::Vector{Int}) = MeasureGate(qubits)
