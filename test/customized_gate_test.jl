include("./../src/YQ.jl")
using .YQ

state = MPSState(3)

function f()
	mat = zeros(ComplexF64, 2,2)
	mat[2,1] = 1
	mat[1,2] = 1
	return mat
end

print(CustomizedGate)
applyGate!(state, cusGate)
print(measure!(state, [1,2], 1024))