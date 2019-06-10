
include("YQ.jl")
using .YQ

net = ITensorNet(ITensor(Index(2),Index(2)))
inds = Index[]
N=3
for i =1:N
	push!(inds, Index(2))
end
for i = 1:N-1
	push!(net, randomITensor(Float64,inds[1], inds[i+1]))
end

print(net)
delete!(net, net[2])
print("\n ========== deleting ======\n")
print(net)