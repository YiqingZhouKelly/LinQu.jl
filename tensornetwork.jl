using ITensors
import Base.push!,
	   Base.length,
	   ITensors.push!,
	   Base.getindex,
	   Base.setindex!,
	   Base.copy,
	   ITensors.copy,
	   Base.deleteat!
struct ITensorNet
	net:: Vector{ITensor}
	ITensorNet(m::Vector{ITensor}) = new(m)
	function ITensorNet(A::ITensor, B::ITensor, C...)
		net = ITensor[]
		push!(net, A, B)
		for tensor ∈ C
			typeof(tensor)==ITensor && push!(net,tensor)
		end
		new(net)
	end
end
getindex(N::ITensorNet, j::Int64) = getindex(N.net,j)
setindex!(N::ITensorNet,j::Int,A::ITensor) = setindex!(N.net,j,A)
length(N::ITensorNet) = length(N.net)
push!(N::ITensorNet, A::ITensor) = push!(N.net,A)
copy(N::ITensorNet) = ITensorNet(copy.(N.net))
# TODO: add iterator

# TODO: check repeated tensor maybe?
function push!(N::ITensorNet, A::ITensor, B...)
	push!(N,A)
	for i=1:length(N)
		typeof(N[i])==ITensor && push!(N,N[i])
	end
end
function push!(N1:: ITensorNet, N2::ITensorNet)
	for i = 1:length(N2)
		push!(N1, N2[i])
	end
	return N1
end
push!(N::ITensorNet, list::Vector{ITensor}) = push!(N,ITensorNet(list))
function contractall(N::ITensorNet)
	#TODO: possible optimization in contraction order
	product = N.net[1]
	for i = 2:length(net)
		# global product
		product*=N.net[i]
	end
	return product
end
findfirst(N::ITensorNet, A::ITensor) = findfirst(N.net, A)
#TODO maybe add next
deleteat!(N::ITensorNet, j::Int) = deleteat!(N.net,j)
delete!(N::ITensorNet, A::ITensor) = deleteat!(N,findfirst(N,A))

function contractall(A::ITensor,B::ITensor,C...)
	net = ITensor[]
	push!(net,A,B)
	for tensor ∈ C
		push!(net,tensor)
	end
	contractall(net)
end

# # == test ==
inds = Index[]

for i =1:1
	push!(inds,Index(2))
end
A = randomITensor(Float64,inds)
B = randomITensor(Float64,inds)
C = randomITensor(Float64,inds)
D = randomITensor(Float64,inds)
N1 = ITensorNet(A,B,C)
N2 = copy(N1)
push!(N1,N2)
print("\n=====before delete:=====\n")
print(N1)
print("\n=======after delete ======\n")
deleteat!(N1,1)	
print(N1)
