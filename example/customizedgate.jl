include("../src/YQ.jl")
using .YQ, Test, Random
import .YQ.data # data() is extended

# define customized QGate
struct RandomSingleGate <: QGate
	rng::MersenneTwister
	seed::Int
	maxangle::Number

	RandomSingleGate(rng::MersenneTwister, seed::Int, maxangle::Number) = new(rng, seed, maxangle)
end
RandomSingleGate(seed::Int, maxangle::Number) = RandomSingleGate(MersenneTwister(seed), seed, maxangle)

reset!(gate::RandomSingleGate) = Random.seed!(gate.rng, gate.seed)

function data(gate::RandomSingleGate)
	params = rand(gate.rng, 4)
	params[2:end] ./= sum(params[2:end].^2)
	theta = params[1]* gate.maxangle
	return cos(theta/2)*I_DATA-sin(theta/2)im* (params[2]*X_DATA+params[3]*Y_DATA+params[4]*Z_DATA)
end

# Built-in interface still work for customized gate
state = MPSState(2)
state_copy = copy(state)
customizedgate = RandomSingleGate(5, π)
apply!(state, customizedgate, 1)
apply!(state, customizedgate, 2)
reset!(customizedgate)
apply!(state_copy, customizedgate, 1)
apply!(state_copy, customizedgate, 2)
@test toExactState(state) ≈ toExactState(state_copy)