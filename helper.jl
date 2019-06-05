# export contractall
function contractall(net::Vector{ITensor})
	product = net[1]
	for i =2:length(net)
		# global product
		product*=net[i]
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

function exact_MPS(exact::ITensor,indexorder,leftlink=Nothing,rightlink=Nothing;kwargs...) #::Array{ITensor,1}
	iter = order(exact)-1
	leftlink!=Nothing && (iter-=1)
	rightlink!=Nothing && (iter-=1)
	remain = copy(exact) # TODO: How to avoid the copy?
	resultMPS = ITensor[]
	for  i = 1:iter
		if leftlink !=Nothing
			U,S,V,leftlink,v = svd(remain,IndexSet(leftlink,indexorder[i]);kwargs...)
		else
			U,S,V,leftlink,v = svd(remain, indexorder[i];kwargs...)
		end 
		push!(resultMPS,U)
		remain = S*V
	end
	push!(resultMPS,remain)
	return resultMPS
end

MPS_exact(mps::MPS) = contractall(mps.A_)
MPS_exact(mpss::MPSState) = MPS_exact(mpss.s)

qgate_itensor(qg::QGate, inds::IndexSet) = ITensor(qg.data, IndexSet(inds,prime(inds)))

function movegauge(qs::MPSState, pos::Int) = position!(qs.s,pos)
function movegauge(qs::MPSState, pos::Vector{Int})
	#now assume 2 quibit gate
	l = leftLim(qs)
	r = rightLim(qs)
	sort!(pos)
end

function minstep(llim::Int, rlim::Int, target::Int)
	# target<llim && (opt=)
	#unfinished
end
