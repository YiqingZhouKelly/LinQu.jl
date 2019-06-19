
struct ITensorNet
	net:: Vector{ITensor}
	ITensorNet() = new(ITensor[])
	ITensorNet(m::Vector{ITensor}) = new(m)
	ITensorNet(A::ITensor...) = ITensorNet(_tuple_array(A))
end #struct
# ==== basics ====
getindex(N::ITensorNet, j::Int) = getindex(N.net,j)
setindex!(N::ITensorNet,j::Int,A::ITensor) = setindex!(N.net,j,A)
length(N::ITensorNet) = length(N.net)
push!(N::ITensorNet, A::ITensor) = push!(N.net,A)
copy(N::ITensorNet) = ITensorNet(copy.(N.net))


findfirst(N::ITensorNet, A::ITensor) = findfirst(x->x==A,N.net)
findall(N::ITensorNet, A::ITensor) = findall(x->x==A,N.net)
#TODO maybe add next
deleteat!(N::ITensorNet, j::Int) = deleteat!(N.net,j)
delete!(N::ITensorNet, A::ITensor) = deleteat!(N,findfirst(N,A))

size(N::ITensorNet) = size(N.net)
iterate(N::ITensorNet,state::Int=1) = iterate(N.net,state)

function delete!(N::ITensorNet, A::ITensor...)
	for tensor ∈ A
		typeof(tensor)==ITensor && delete!(N,tensor)
	end
end
# === advanced ops ===
# TODO: check repeated tensor maybe?
function push!(N::ITensorNet, A::ITensor...)
	for tensor ∈ A
		push!(N,tensor)
	end
end
function push!(N1:: ITensorNet, N2::ITensorNet)
	for tensor ∈ N2
		push!(N1,tensor)
	end
	return N1
end
push!(N::ITensorNet, list::Vector{ITensor}) = push!(N,ITensorNet(list))

function contractall(N::ITensorNet)
	#TODO: possible optimization in contraction order
	product = N.net[1]
	for i = 2:length(N)
		# global product
		product =product * N.net[i]
	end
	return product
end

function contractAll(N::ITensorNet) # new
	#TODO: possible optimization in contraction order
	product = N.net[1]
	for i = 2:length(N)
		# global product
		product =product * N.net[i]
	end
	return product
end


function contractall(A::ITensor,B::ITensor,C...)
	net = ITensor[]
	push!(net,A,B)
	for tensor ∈ C
		push!(net,tensor)
	end
	contractall(net)
end

function contractsubset!(N::ITensorNet, A::ITensor, B::ITensor, C...)
	result = A*B
	delete!(N,A,B)
	for tensor ∈ C
		result*= tensor
	end
	delete!(N,C)
	push!(N,result)
	return N
end

