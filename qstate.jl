
include("./../ITensors/src/ITensors.jl")

using Main.ITensors
import Main.ITensors.linkind,
	   Main.ITensors.getindex,
	   Base.length,
	   Base.copy,
	   Base.push!,
	   Main.ITensors.noprime,
	   Main.ITensors.noprime!,
	   Main.ITensors.prime,
	   Main.ITensors.svd,
	   Main.ITensors.position!,
	   Main.ITensors.setindex!,
	   Main.ITensors.svd,
	   Main.ITensors.commonindex,
	   Main.ITensors.linkind,
	   Main.ITensors.leftLim,
	   Main.ITensors.rightLim,
	   Main.ITensors.iterate
include("./helper.jl")
include("./qgate.jl")
include("tensornet.jl")
include("qgateset.jl")
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
iterate(m::MPSState) = iterate(m)
getlink(qs::MPSState,j::Int) = linkind(MPS(qs),j)
function getlink(qs::MPSState, pos::Vector{Int})
	sortedpos = sort(pos)
	leftend = sortedpos[1]
	rightend = sortedpos[length(sortedpos)]
	leftlink = Nothing 
	rightlink= Nothing
	leftend !=1 && (leftlink=getlink(qs,leftend-1))
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
function getfree(qs::MPSState, pos::Vector{Int})
	toreturn = Index[] 
	# print(typeof(pos))
	for i =1:length(pos)
		push!(toreturn,getfree(qs,pos[i]))
	end
	print("good here\n")
	return toreturn
end


leftLim(m::MPSState) = leftLim(m.s)
rightLim(m::MPSState) = rightLim(m.s)


MPS_exact(mps::MPS) = contractall(mps.A_)
MPS_exact(mpss::MPSState) = MPS_exact(mpss.s)

function position!(qs::MPSState, j::Int) 
	psi = qs.s
	N = length(psi)

	while leftLim(psi) < (j-1)
		ll = leftLim(psi)+1
		s = getfree(qs,ll)
		if ll == 1
	  		(Q,R) = qr(psi[ll],s)
		else
	  		li = linkind(psi,ll-1)
	  		(Q,R) = qr(psi[ll],s,li)
		end
		psi[ll] = Q
		psi[ll+1] *= R
		psi.llim_ += 1
	end

	while rightLim(psi) > (j+1)
		rl = rightLim(psi)-1
		s = getfree(qs,rl)
		if rl == N
	  		(Q,R) = qr(psi[rl],s)
		else
	  		ri = linkind(psi,rl)
	  		(Q,R) = qr(psi[rl],s,ri)
		end
		psi[rl] = Q
		psi[rl-1] *= R
		psi.rlim_ -= 1
	end
	psi.llim_ = j-1
	psi.rlim_ = j+1
end

# function position!(psi::MPS,
#                    j::Integer)

# end

function movegauge!(qs::MPSState, pos::Int)
	position!(qs,pos)
	return pos
end

function movegauge!(qs::MPSState, pos::Vector{Int})
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
		qs[pos[i]] = new[i]
	end
end

function applylocalgate!(qs::MPSState,qg::QGate; kwargs...)
	center = movegauge!(qs,pos(qg))	
	llink,rlink = getlink(qs, pos(qg))
	wires = IndexSet(getfree(qs,pos(qg)))
	net = ITensorNet(qgate_itensor(qg,wires))
	for i ∈ pos(qg)
		push!(net, qs[i])
	end
	exact = noprime!(contractall(net))
	approx = exact_MPS(exact, wires, llink, rlink; kwargs...)
	replace!(qs, approx, pos(qg))
	return qs
end

function applylocalgate!(qs::MPSState, qg::QGateSet; kwargs...) 
	# TODO: Need to define iterate() for QGateSet, not tested
	for gate ∈ qgate
		applylocalgate!(qs,gate;kwargs...)
	end
	return qs
end

function applynonlocalgate!(qs::MPSState,qgate::QGate; kwargs...)
	# TODO: not implemented
	error("NO implementation\n")
end

function nonlocal_local(qg::QGate) #:: QGateSet
#TODO : not implemented
	error("NO implementation\n")
end
function checklocal(pos::Vector{Int})
	if length(pos) ==1
		return true
	else
		for i =2:length(pos)
			if pos[i] != pos[i-1]+1
				return false
			end
			return true
		end
	end
end
checklocal(qg::QGate) = checklocal(pos(qg))


# initialstate = MPSState(4)
# gate = XGate(3)
# gate2 = YGate(5)
# gs = QGateSet([gate,gate2])
# for i ∈ gs
# 	print("test\n")
# end
# print(checklocal([5,4]))
# print(applylocalgate!(initialstate,gate))

#TODO: meybe check if it is still a valid MPS


