
@testset "Toffoli test" begin
	N = 3
	state = MPSState(N)
	apply!(state, X(1))
	apply!(state, X(2))
	state_e = toExactState(state)
	circuit = QCircuit(N)
	add!(circuit,     H(3),
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
	apply!(state_e, TOFFOLI(1,2,3))
	RoundToZero # set rounding mode 
	for i = 0:1
		for j = 0:1
			for k = 0:1
				@test isapprox(round(probability(state, [i,j,k])),probability(state_e, [i,j,k]))
			end
		end
	end
end