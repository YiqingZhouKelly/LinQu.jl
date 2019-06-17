mutable struct ExactState <: QState
	s:: ITensor
	function ExactState(N::Int, init::Vector{T}) where T
		norm(init) != 1 && error("initial state must have norm 1\n")
		net = ITensorNet()
		for i =1: N
			push!(net, ITensor(init, Index(2,"Site, s=$(i)")))
		end
		new(contractall(net))
	end
	ExactState(N::Int) = ExactState(N, [1,0])
end # struct

length(es::ExactState) = length(IndexSet(es.s))
ITensor(es::ExactState) = es.s

function getindex(es::ExactState, n::Int)
	tag = "Site, s=$(n)"
	return findindex(IndexSet(es.s), tag)
end
function setindex!(es::ExactState)
	error("No support for changing index of an exact state\n")
end

getfree(es::ExactState, n::Int) = getindex(es,n)
*(es::ExactState, op::ITensor) = *(es.s, op)

function applygate!(es::ExactState, qg::QGate)
	inds = IndexSet()
	for i ∈ pos(qg)
		push!(inds, es[i])
	end
	gate = ITensor(qg.data, IndexSet(inds, prime(inds)))
	es.s = gate*es.s
	noprime!(es.s)
	return es
end
applylocalgate!(es::ITensor, qg::QGate) = applygate!(es,qg)