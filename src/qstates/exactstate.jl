
mutable struct ExactState <: QState
	site:: ITensor
	ExactState(T::ITensor) = new(T)
	function ExactState(N::Int, init::Vector{T}) where T
		norm(init) != 1 && error("initial state must have norm 1\n")
		net = ITensor[]
		for i =1: N
			push!(net, ITensor(init, Index(2,"Site, q=$(i)")))
		end
		new(prod(net))
	end
end #struct

function ExactState(N::Int)
	shape = ones(Int, N).*2
	D = zeros(shape...)
	D[1]=1
	inds = [Index(2, "Site, q=$(i)") for i=1:N]
	return ExactState(ITensor(D, inds...))
end

copy(state::ExactState) = ExactState(copy(state.site))
isapprox(state1::ExactState, state2::ExactState) = isapprox(state1.site,state2.site)

function toMPSState(state::ExactState; kwargs...)
	numQubits = length(IndexSet(state.site))
	leftLink = nothing
	remain = copy(state.site)
	sites = ITensor[]
	for i =1:numQubits-1
		if leftLink != nothing
			U,S,V,leftLink,v = svd(remain,
								   IndexSet(leftLink, findindex(remain, "q=$(i)"));
								   kwargs...)
		else
			U,S,V,leftLink,v = svd(remain, findindex(remain, "q=$(i)"); kwargs...)
		end
		push!(sites, replacetags(U, "u", "l=$(i)"))
		S = replacetags(S, "u", "l=$(i)")
		leftLink = replacetags(leftLink, "u", "l=$(i)")
		remain = S*V
	end
	push!(sites, remain)
	return MPSState(sites,QubitSiteMap(numQubits), numQubits-1, numQubits+1)
end
