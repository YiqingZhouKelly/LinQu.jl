# include("./YQ.jl")
# using .YQ

V = 4
d = 5
N = 16

state = MPSState(V+1)

function SU2Circuit(V,d,N)
	circuit = QCircuit()
	swapAlpha(θ::Real)=reshape(exp(reshape(-θ/2im*SWAP_DATA,(4,4))),(2,2,2,2))
	SA(q1::Int, q2::Int, param::Vector{T} where {T<:Real}) = CustomizedGate(swapAlpha,[q1,q2],param,"SA")
	function paramBlock()
		pb = QGateBlock()
		for i = 1:V
			push!(pb, SA(i,i+1, rand(Float64,1)))
		end
		push!(pb,  SA(1, V, rand(Float64,1)))
		return pb
	end

	push!(circuit, X(2), H(2), CNOT(2,3),X(4), H(4), CNOT(4,5))

	prefix = Array{QGateBlock,1}(undef, 2)
	prefix[1] ,prefix[2] =  QGateBlock(), QGateBlock()
	push!(prefix[1], X(1), H(1), CNOT(1, V+1))
	push!(prefix[2], SWAP(1, V+1))

	for s = 1:N-V
		push!(circuit, prefix[s%2+1])
		for r = 1:d
			push!(circuit, paramBlock())
		end
		push!(circuit, MEASURE_RESET([1]))
	end
	return circuit
end

circuit = SU2Circuit(V,d,N)
for shot = 1:4096
	runCircuit!(MPSState(V+1), circuit)
	print("\n")
end