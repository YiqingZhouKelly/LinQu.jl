
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
	push!(qc, SwapGate(1,2))
	push!(qc, XGate(1))
	push!(qc, HGate(2))
	push!(qc, CNOTGate(1,2))
	push!(qc, CNOTGate(2,3))
	minswap_localize!(qc)
	runlocal!(qc)
	print(qc)
elseif test == "contraction"
	m = MPSState(3)
	print(m)
	X = XGate(1)
	cnot = CNOTGate(1,2)
	applylocalgate!(m, X)
	print(m)
	applylocalgate!(m, cnot)
	print(m)
elseif test == "dim"
	mps = MPSState(3)
	H =HGate(2)
	CNOT = CNOTGate(1,2)
	applylocalgate!(mps, H)
	print(mps)
	applylocalgate!(mps,CNOT)
	# applylocalgate!(mps, CNOT)	
	print(mps)
elseif test == "simple"
	qc = QCircuit(5)
	# push!(qc, HGate(2))
	# push!(qc, HGate(3))
	# push!(qc, HGate(4))
	push!(qc, CNOTGate(1,2))
	# minswap_localize!(qc)
	runlocal!(qc)
	print(qc)
elseif test == "control_target"
	qc = QCircuit(3)
	push!(qc, XGate(2))
	print(qc)
	print("\n==============split =============\n")
	push!(qc, SwapGate(1,2))
	# push!(qc, CNOTGate(1,2))
	runlocal!(qc)
	print(qc)
elseif test == "YGate"
	qc = QCircuit(3)
	push!(qc, YGate(3))
	runlocal!(qc)
	print(qc)
else
	print("No test named $(test) is found...\n")
end