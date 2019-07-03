include("./../src/YQ.jl")
using .YQ, Test

@testset "MPSState & ExactState consistency test" begin
	    mps = MPSState(5)
	    exact = toExactState(mps)
	    circuit = randomQCircuit(5, 40)
	    apply!(mps, circuit)
	    apply!(exact, circuit)
	    @test toExactState(mps) ≈ exact
end