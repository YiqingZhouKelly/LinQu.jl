include("./../YQ.jl")
using .YQ

N = 4
d = 5
V = 16

state = MPSState(N+1)

# swap alpha
swapAlpha(θ::Real)=expm(-θ/2im*SWAP_DATA)
SA(q1::Int, q2::Int, param::Vector{Real}) = CustomizedGate(swapAlpha, param, [q1,q2],"SA")

#parameterized gate block (repeated d times)
function paramBlock(param::Vector{Real})
	paramIdx = 1
	paramBlock = QGateblock()
	for i = 1:N-1
		push!(paramBlock, SA(i,i+1, param[paramIdx:paramIdx]))
	end
	push!(paramBlock, SA(1,N))
	return 
end

function fillParamBlock!(block::QGateblock, θ::Vector{Float64})
	for i = 1:length(θ)
		changeParam!(gates(block)[i], θ[i])
	end
end

step_= N-V #step
qubits_ = V+1 #qubits
repeats_ = d #repeat
θ = rand(Float64,s,r,q) # initialize parameters


initBlock = QGateblock()
push!(initBlock, X(2), H(2), CNOT(2,3))
push!(initBlock, X(4), H(4), CNOT(4,5))
applyGate!(state, initBlock)

prefix = Array{QGateblock,1}(undef, 2)
prefix[1]. prefix[2] =  QGateblock(), QGateblock()
push!(prefix[1], X(1), H(1), CNOT(1, N+1))
push!(prefix[2], SWAP(1, N+1))

for s = 1:step_
	applyGate!(state, prefix[s%2])
	for r = 1:d
		fillParamBlock!(paramBlock, θ[s, r, :])
		applyGate!(state, paramBlock)
	end
	measure
end
