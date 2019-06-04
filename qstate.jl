using ITensors
import ITensors.linkind,
	   ITensors.getindex,
	   Base.length,
	   Base.copy,
	   ITensors.noprime!,
	   ITensors.svd,
	   ITensors.position!,
	   ITensors.setindex!,
	   ITensors.svd,
	   ITensors.commonindex,
	   ITensors.linkind
# Move to a module later...

abstract type QState end

# error check no valid subclass function fits the call

struct MPSState <: QState
	s::MPS
	# freelist:: Vector{Index} #?? is it really needed

	# MPSState() = new(MPS())

	function MPSState(N::Int, init::Vector{T}) where {T}
		linklist = Index[]
		freelist = Index[]
		itensorlist = ITensor[]
		for i = 1 : N 
			push!(freelist,Index(2))
			if i < N
				push!(linklist,Index(1))
			end
			if i == 1
				push!(itensorlist, ITensor(init, linklist[i],freelist[i]))
			elseif i == N
				push!(itensorlist,ITensor(init, linklist[i-1],freelist[i]))
			else
				push!(itensorlist,ITensor(init,linklist[i-1],linklist[i],freelist[i]))
			end
		end
		new(MPS(N,itensorlist,0,N+1))
	end

	MPSState(N::Int) = MPSState(N,[1.,0.]) #initialize to |0> state
end #struct

getindex(st::MPSState,n::Int) = getindex(st.s,n) # ::ITensor
setindex!(st::MPSState,T::ITensor,n::Integer) = setindex!(st.s,T,n) 
MPS(qs::MPSState) = qs.s #::MPS
length(m::MPSState) = length(m.s)


# copy(st::MPSState) = MPSState(copy(st.s), ) # Need to think about how to get the free list...
getlink(qs::MPSState,j::Int) = linkind(MPS(qs),j)

function getfree(qs::MPSState,j::Int)
	links = Index[]
	i>1 && push!(links, getlink(qs,j-1))
	i<length(qs) && push!(links,getlink(qs,j))
	allinds = IndexSet(qs[j]) 
end




function noprime!(A::ITensor)
	noprime!(IndexSet(A))
	A
end

function applygate!(qs::MPSState, qg::QGate)
	movegauge!(qs,pos)
	igate_ = igate(qs,qg)
	# == contraction goes here ==
	product = contractgate!(igate_,[qs[i] for i ∈ pos(qg)]) # TODO:check site continuity
	itensor_vector = toMPS(product,range(qg))
	replacesites!(qs,itensor_vector,pos(qg))
end

function movegauge(qs::MPSState, qg::QGate)
	#TODO: optimization - find the shortest way to move the guage
	position!(MPS(qs),pos(qg)[1])
end

function igate(qs::MPSState, qg::QGate)
	inds = [getfree(qs,i) for i ∈ pos(qg)]
	inds = IndexSet(inds, prime(inds))
	igate_ = ITensor(gatematrix(qg), inds)
end

function contractgate!(igate_:: ITensor, sites:: Vector{ITensor})
	for site ∈ sites
		igate_*= site
	end
	return igate_
end

function toMPS(exact::ITensor, N::Int; kwargs...)
	# TODO: how to detect left indices??
	toreturn = ITensor[]
	leftIndex = Index(2) # need fix
	remain = copy(exact)
	for i = 1:N-1
		U,S,V,u,v = svd(remain,leftIndex; kwargs...)
		push!(toreturn,U)
		leftIndex = commonindex(U,S) #wrong... should also include the phyiscal bond
		remain = S*V
	end 
	push!(toreturn,remain)
	return toreturn
end

function replacesites!(qs::MPSState,newsites::Vector{ITensor}, pos::Vector{Int})
	for i = 1: length(pos)
		qs[pos[i]] = newsites[i]
	end
	return qs
end		
"""
function applygate!(qs::MPSState, gate::Tuple{Vector{Float64},Vector{Int}})
	(data,pos) = gate
	# position!(...) #Move the gauge
	freeinds = IndexSet([getfree(qs,ii) for ii ∈ pos])
	print("inds:", inds)
	product = ITensor(data,IndexSet(freeinds,prime(freeinds)))
	for ii ∈ pos
		product*=qs.s[ii]
	end
	noprime!(product)
	#get back to mps format 
	itensors = tsvd(product, length(pos))
end	

function toMPS(A::ITensor, N::Int)
	for i = 1:N

	end
end
"""

# struct MixedState <: QState
# 	s::MPS
# end 

# struct ExactState <: QState
# 	s:: MPS
# end 

# ===== mini test ====
initstate = rand(Float64,2)
initstate/=norm(initstate)
# print("norm = ", norm(initstate))
m = MPSState(3,initstate)
print(m)
gate = ([0.,1.,1.,0.],[2])
print(applygate!(m,gate))


