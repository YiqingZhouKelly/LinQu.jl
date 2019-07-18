include("./../src/YQ.jl")
using .YQ, Test

function f()
	N = 4
	state = MPSState(N)
	circuit = QCircuit(N)
	add!(circuit, X(1),
					  X(2),
					  H(3),
					  CNOT(2,3),
					  TDAG(3),
					  CNOT(1,3),
					  T(3),
					  CNOT(2,3),
					  TDAG(3),
					  CNOT(1,3),
					  T(3),
					  H(3),
					  TDAG(2),
					  CNOT(1,2),
					  TDAG(2),
					  CNOT(1,2),
					  T(1),
					  S(2))
	apply!(state, circuit)
	result = measure!(state, [1,2,3], 1024)
end

@profiler f()
