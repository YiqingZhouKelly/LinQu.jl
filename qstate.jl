using ITensors
include("./helper.jl")
include("./qgate.jl")
import ITensors.linkind,
	   ITensors.getindex,
	   Base.length,
	   Base.copy,
	   ITensors.noprime,
	   ITensors.prime,
	   ITensors.svd,
	   ITensors.position!,
	   ITensors.setindex!,
	   ITensors.svd,
	   ITensors.commonindex,
	   ITensors.linkind,
	   ITensors.findtags
# Move to a module later...

# == helpers that should not belong here == 

# == helpers that should not belong to here end == 
abstract type QState end

# error check no valid subclass function fits the call

struct MPSState <: QState
	s::MPS
	function MPSState(N::Int, init::Vector{T}) where {T}
		itensors = ITensor[]
		rightlink,leftlink
		for i =1:N
			global rightlink, leftlink
			if i ==1
				rightlink = Index(1)
				push!(itensors, ITensor(init, rightlink,Index(2)))
			elseif i == N
				push!(itensors, ITensor(init, leftlink, Index(2)))
			else
				rightlink = Index(1)
				push!(itensors, ITensor(init, leftlink, rightlink, Index(2)))
			end
			leftlink = rightlink
		end
		new(MPS(N,itensors,0,N+1))
	end

	MPSState(N::Int) = MPSState(N,[1.,0.]) #initialize to |0> state
end #struct

getindex(st::MPSState,n::Int) = getindex(st.s,n) # ::ITensor
setindex!(st::MPSState,T::ITensor,n::Integer) = setindex!(st.s,T,n) 
MPS(qs::MPSState) = qs.s #::MPS
length(m::MPSState) = length(m.s)

getlink(qs::MPSState,j::Int) = linkind(MPS(qs),j)
function getlink(qs::MPSState, pos::Vector{Int})
	sortedpos = sort(pos)
	leftend = sortedpos[1]
	rightend = sortedpos[length(sortedpos)]
	leftlink,rightlink = Nothing
	leftend !=1 && (leftlink=getfree(qs,leftend-1))
	rightend != length(qs) && (rightlink = getlink(qs, rightend))
	return leftlink, rightlink
end	
function getfree(qs::MPSState,j::Int) # return Index if only have 1 free, or a Array{Index,1} o.w.
	links = Index[]
	j>1 && push!(links, getlink(qs,j-1))
	j<length(qs) && push!(links,getlink(qs,j))
	freeset = setdiff(IndexSet(qs[j]),links)  
	if length(freeset)==1
		return freeset[1]
	end
	freeset
end
getfree(qs::MPSState, pos::Vector{Int}) = getfree.(qs,pos)


leftLim(m::MPSState) = leftLim(m.s)
rightLim(m::MPSState) = rightLim(m.s)


MPS_exact(mps::MPS) = contractall(mps.A_)
MPS_exact(mpss::MPSState) = MPS_exact(mpss.s)
function position!(qs::MPSState, pos::Int) 
	# print("\n in position!\n")
	position!(qs.s,pos)
end
function movegauge!(qs::MPSState, pos::Int)
	# print("\nmovegauge for single qubit gate")
	position!(qs,pos)
	return pos
end

function movegauge!(qs::MPSState, pos::Vector{Int})
	print("here")
	if length(pos) == 1
		return movegauge!(qs,pos[1])
	end
	#2 quibit gate
	l = leftLim(qs)
	r = rightLim(qs)
	# TODO: check whether sort!(pos) is needed
	center = optpos(l,r,pos)
	position!(qs,center)
	return center
end

function replace!(qs::MPSState,new::Vector{ITensor}, pos::Vector{Int}) 
	for i =1 : length(pos)
		qs[i] = new[i]
	end
end

function applylocalgate!(qs::MPSState,qg::QGate; kwargs...)
	center = movegauge!(qs,pos(qg))	
	# print("\ncheckpoint0\n")
	llink,rlink = getfree(qs, pos(qg))
	wires = IndexSet(getfree(qs,pos(qg)))
	net = ITensorNet(qgate_itensor(qg,wires))
	# print("\ncheckpoint1\n")
	for i =1:length(pos(qg))
		push!(net,qs[i])
	end
	# print("\ncheckpoint2\n")
	exact = noprime(contractall(net))
	approx = exact_MPS(exact, wires, llink, rlink; kwargs...)
	replace!(qs, approx, pos(qg))
end

initialstate = MPSState(4)
gate = XGate(3)
print(applylocalgate!(initialstate,gate))


	#TODO: meybe check if it is still a valid MPS


