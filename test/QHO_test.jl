include("./../src/YQ.jl")
using .YQ

state = MPSState(5)
θ= 0.5
ϕ= -π/2
λ= π/2

function CU3Func(θ,ϕ,λ)
	cu3 = zeros(ComplexF64, 2,2,2,2)
	cu3[1,1,1,1] = 1
	cu3[1,2,1,2] = 1
	cu3[2,1,2,1] = cos(θ/2)
	cu3[2,1,2,2] = exp(-λ*1im)*sin(θ/2)
	cu3[2,2,2,1] = exp(ϕ*1im)*sin(θ/2)
	cu3[2,2,2,2] = exp((λ+ϕ)*1im)* cos(θ/2)
	return cu3
end

function CHFunc()
    ch = zeros(ComplexF64,2,2,2,2)
    ch[1,1,1,1] = 1
    ch[1,2,1,2] = 1
    ch[2,1,2,1] = 1/√2
	ch[2,1,2,2] = 1/√2
	ch[2,2,2,1] = 1/√2
	ch[2,2,2,2] = -1/√2
	return ch
end

CH(qubits::Vector{Int}) = CustomizedGate(CHFunc, Int[], qubits)
CU3(qubits::Vector{Int}) = CustomizedGate(CU3Func, [θ,ϕ,λ], qubits)
applyGate!(state, CNOT(1,3))
applyGate!(state, X(3))
applyGate!(state, CU3([3,1]))
applyGate!(state, X(3))
applyGate!(state, CNOT(3,5))
applyGate!(state, CNOT(1,5))
applyGate!(state, X(5))
applyGate!(state, H(2))
applyGate!(state, H(5))
applyGate!(state, CNOT(2,5))
applyGate!(state, H(2))
applyGate!(state, H(5))
applyGate!(state, X(3))
applyGate!(state, X(5))
applyGate!(state, CU3([3,2]))
applyGate!(state, X(3))
applyGate!(state, CNOT(1,2))
applyGate!(state, H(4))
applyGate!(state, CNOT(4,2))
applyGate!(state, CNOT(4,1))
applyGate!(state, H(4))
applyGate!(state, CH([4,1]))

print(measure!(state, [1,2], 1024)./1024)


