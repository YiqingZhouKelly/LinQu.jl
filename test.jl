
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
else
	print("No test named $(test) is found...\n")
end