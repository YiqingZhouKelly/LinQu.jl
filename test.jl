
include("YQ.jl")
using .YQ

test = ARGS[1]
if test== "delete!"
	net = ITensorNet(ITensor(Index(2),Index(2)))
	inds = Index[]
	N=3
	for i =1:N
		push!(inds, Index(2))
	end
	for i = 1:N-1
		push!(net, randomITensor(Float64,inds[1], inds[i+1]))
	end
	delete!(net, net[2], net[1])
	print("\n ========== deleting ======\n")
	print(net)

elseif test == "naive_local"
	qc  =QCircuit(5)
	print(qc)
	# push!(qc, SwapGate(1,2))
	push!(qc, CNOTGate(4,1))
	minswap_localize!(qc)
	runlocal!(qc)
elseif test == "contraction"
	m = MPSState(3)
	print(m)
	X = XGate(1)
	cnot = CNOTGate(1,2)
	applylocalgate!(m, X)
	print(">>>>>>>>>>>>>>>>>>applying X on 1...\n")
	print(m)
	print(">>>>>>>>>>>>>>>>>>applying CNOT on 1,2...\n")
	applylocalgate!(m, cnot)
	print(m)
else
	print("No test named $(test) is found...\n")
end