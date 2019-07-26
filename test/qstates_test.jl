@testset "qstate_test" begin
    @testset "MPSState & ExactState consistency test" begin
    	    mps = MPSState(5)
    	    exact = toExactState(mps)
    	    circuit = randomQCircuit(5, 40)
    	    apply!(mps, circuit)
    	    apply!(exact, circuit)
            config = rand(0:1, 5)
            for i =1:10
                @test abs(probability(mps, config)-probability(exact, config)) < 1e-10
            end
    end

    @testset "MPSState measure test" begin    
        @testset "measure single qubit test" begin
            zero_state = MPSState(1)
            one_state = MPSState(1)
            apply!(one_state, X, ActPosition(1))
            zero_result = measure!(zero_state, 1, 100)
            one_result = measure!(one_state, 1, 100)
            @test sum(zero_result) == 0
            @test prod(one_result) ==1
        end
        @testset "measure! single qubit test" begin
            state = MPSState(1)
            apply!(state, H, ActPosition(1))
            result = collapse!(state, 1)
            result2 = measure!(state, 1, 100)
            if result==0
            	@test sum(result2) == 0
            else
            	@test prod(result2) ==1
            end
    	end
    	@testset "measure single qubit in X basis" begin
    	    state = MPSState(1)
            apply!(state, H, ActPosition(1))
            basis = add!(QGateBlock(), H, ActPosition(1))
            result = measure!(state, basis, 1, 1024)
            @test sum(result) == 0
    	end
        @testset "measure multiple qubits test" begin
            @testset "Throw away probability" for binary in [true, false]
                state = MPSState(2)
                apply!(state, H, ActPosition(1))
                apply!(state, CNOT, ActPosition(1,2))
                if binary
                    result = measure!(state, [1,2], 20; binary = binary)
                    for i = 1:20
                        @test result[i,1] == result[i,2]
                    end
                else
                    result = measure!(state, [1,2], 20; binary = binary)
                    for i=1:20
                        @test result[i]==0 || result[i]==3
                    end
                end
            @testset "Keep probability as a by-product" begin
                state = MPSState(2)
                apply!(state, H, ActPosition(1))
                apply!(state, CNOT, ActPosition(1,2))
                    result, prob = measure!(state, [1,2], 20; probability=true)
                for i = 1:20
                    @test result[i,1] == result[i,2]
                    @test prob[i] ≈ 0.5
                end
            end
            end
        end
        @testset "measure! multiple qubits test" begin
            state = MPSState(2)
            apply!(state, H, ActPosition(1))
            apply!(state, CNOT, ActPosition(1,2))
            result = collapse!(state, [1,2])
            result2 = measure!(state, [1,2], 100)
            for i = 1:100
                @test result2[i,:] == result
            end
        end
    end

    @testset "probability() test" begin
         state_m = MPSState(5)
         state_e = ExactState(5)
         apply!(state_m, H(3))
         apply!(state_e, H(3))
         config = rand(0:1, 5)
         @test probability(state_m, config) ≈ probability(state_e, config)
    end
end