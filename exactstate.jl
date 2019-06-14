struct ExactState <: QState
	s:: ITensor
	function ExactState(N::Int, init::Vector{T}) where T
		norm(init) != 1 && error("initial state must have norm 1\n")
		net = ITensorNet()
		for i =1: N
			push!(net, ITensor(init, Index(2,"Site, s=$(i)")))
		end
		new(contractall(net))
	end
end # struct

ITensor(es::ExactState) = es.s
function getindex(es::ExactState, n::Int)
	tag = "Site, s=$(n)"
	return findindex(IndexSet(es.s), tag)
end
function setindex!(es::ExactState)
	error("No support for changing index of an exact state\n")
end