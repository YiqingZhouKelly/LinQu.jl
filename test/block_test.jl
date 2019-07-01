include("./../src/YQ.jl")
using .YQ, Test

@testset "block test" begin
    @testset "flatten test" begin
		circuit = QCircuit(5)
		block2 = QGateBlock()
		block1 = QGateBlock()
		add!(block1, X(1), X(2), X(3), Y(3))
		add!(block2, block1(5,3,2))
		add!(circuit, block2(5,4,3,2,1))
		flatCircuit = QCircuit(5)
		add!(flatCircuit, X(1), X(3), X(4), Y(4))
		@test flatten(circuit) == flatCircuit
	end

	@testset "block extract param test" begin
		circuit = QCircuit(5)
		block2 = QGateBlock()
		block1 = QGateBlock()
		add!(block1, Rx[π](1), Rx[π/2](2), Rx[π/4](3), Ry[π/8](3))
		add!(block2, block1(5,3,2))
		add!(block2, X(1))
		add!(block2, block1(2,3,5))
		params = extractParams(block2)
		@test params ≈ repeat([π, π/2,π/4, 666],2)
	end

	@testset "block insert param test" begin
	    circuit = QCircuit(5)
		block2 = QGateBlock()
		block1 = QGateBlock()
		add!(block1, Rx(1), X(2), Rx(3), Ry(3))
		addCopy!(block2, block1(5,3,2))
		add!(block2, X(1))
		addCopy!(block2, block1(2,3,5))
		newparams = rand(Float64, 6)
		insertParams!(block2, newparams)
		@test extractParams(block2) ≈ newparams
	end
end
