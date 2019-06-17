
function exact_MPS(exact::ITensor,indexorder,
				   leftlink=Nothing,rightlink=Nothing;
				   kwargs...) #::Array{ITensor,1}
	iter = order(exact)-1
	leftlink != Nothing  && (iter-=1)
	rightlink != Nothing && (iter-=1)
	remain = copy(exact) # TODO: How to avoid the copy?
	resultMPS = ITensor[]
	for  i = 1:iter
		if leftlink !=Nothing
			U,S,Vh,leftlink,v = svd(remain,IndexSet(leftlink,indexorder[i]);kwargs...)
		else
			U,S,Vh,leftlink,v = svd(remain, indexorder[i];kwargs...)
		end 
		push!(resultMPS,U)
		remain = S*Vh 
	end
	push!(resultMPS,remain)
	return resultMPS
end

function exactMPS(exact::ITensor, pos::Vector{Int})
	leftLink = Nothing
	rightLink = Nothing
	remain = copy(exact)
	resultMPS = ITensor[]
	sorted = sort(pos)
	sorted==pos && error("local gate should have sorted pos\n")
	pos[1]!=1 && (leftLink = findindex(exct, "Link, l=$()"))
end

function stepsize(llim::Int, rlim::Int, target::Int)
	if target<llim
		distance = rlim-target
	elseif target<rlim
		distance = (target-llim)+ (rlim-target)
	else
		distance = target-llim
	end
	return distance
end

function optpos(llim::Int, rlim::Int, targets::Vector{Int})
	distances = stepsize.(llim,rlim,targets)
	return targets[argmin(distances)]
end

function noprime!(A::ITensor) 
	noprime!(IndexSet(A))
	return A
end

function _tuple_array(T)
	Tarr = [t for t in T]
	return Tarr
end
