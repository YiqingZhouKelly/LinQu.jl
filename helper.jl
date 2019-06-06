
using ITensors

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
	distances = stepsize.(llim,rlim,targets) #not sure if the not operator is working
	return targets[argmin(distances)]
end

function noprime!(A::ITensor)
	""" set prime level of all Indices connected to A to 0"""
	noprime!(IndexSet(A))
	A
end 