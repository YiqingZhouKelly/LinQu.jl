
function exact_MPS(exact::ITensor,indexorder,
				   leftlink=Nothing,rightlink=Nothing;
				   kwargs...) #::Vector{ITensor}
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

function exactMPS(exact::ITensor, pos::Vector{Int}, N=-1; kwargs...)
	# print("\nposition:", position, "")
	N ==-1 && (N = order(exact))
	leftLink = rightLink = Nothing
	remain = exact
	resultMPS = ITensor[]
	sorted = sort(pos)
	# sorted!=pos && error("local gate should have sorted pos\n")
	#TODO: check for consecutive site
	# print("remain = ", remain,"\n")
	# print("looking for Link, l=$(pos[1]-1)\n")
	# print(findinds(remain, "Link, l=$(pos[1]-1)"),"\n")
	sorted[1]!=1 && (leftLink = findindex(remain, "Link, l=$(sorted[1]-1)"))
	resultMPS = ITensor[]
	for i = 1: length(pos)-1
		if leftLink != Nothing
			leftInds=IndexSet(leftLink, findindex(remain, "Site, s=$(pos[i])"))
			U,S,Vh,leftLink,v = svd(remain, 
								leftInds;
								kwargs...)
		else
			U,S,Vh,leftLink,v = svd(remain, 
									findindex(remain, "Site, s=$(pos[i])"); 
									kwargs...)
		end
		leftLink = replacetags(leftLink, "u", " l=$(pos[i])")
		U = replacetags(U, "u", " l=$(pos[i])")
		S = replacetags(S, "u", " l=$(pos[i])")
		push!(resultMPS, U)
		remain = S*Vh
	end
	push!(resultMPS, remain)
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
