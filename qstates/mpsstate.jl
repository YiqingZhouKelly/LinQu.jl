
struct MPSState <: QState
	s::MPS
	function MPSState(N::Int, init::Vector{T}) where {T}
		itensors = ITensor[]
		rightlink,leftlink
		for i =1:N
			global rightlink, leftlink
			if i ==1
				rightlink = Index(1, "Link, l=$(i)")
				push!(itensors, ITensor(init, rightlink,Index(2, "Site, s=$(i)")))
			elseif i == N
				push!(itensors, ITensor(init, leftlink, Index(2, "Site, s=$(i)")))
			else
				rightlink = Index(1, "Link, l=$(i)")
				push!(itensors, ITensor(init, leftlink, rightlink, Index(2, "Site, s=$(i)")))
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

getlink(qs::MPSState,j::Int) = linkindex(MPS(qs),j)
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
	links = IndexSet()
	j>1 && push!(links, getlink(qs,j-1))
	j<length(qs) && push!(links,getlink(qs,j))
	freeind = uniqueinds(IndexSet(qs[j]),links)
	print(freeind,"\n")
	Index(freeind)
	# return freeind
end

function getfree(qs::MPSState, pos::Vector{Int})
	freeinds = Index[] 
	for i ∈ pos
		push!(freeinds,getfree(qs,i))
	end
	return freeinds
end

leftLim(m::MPSState) = leftLim(m.s)
rightLim(m::MPSState) = rightLim(m.s)

function MPS_exact(mps::MPS) 
	result = mps.A_[1]
	for i =2:length(mps.A_)
		result*=mps.A_[i]
	end
	return result
end
MPS_exact(mpss::MPSState) = MPS_exact(mpss.s)

function applylocalgate!(qs::MPSState,qg::QGate; kwargs...)
	center = movegauge!(qs,pos(qg))
	qs[center] /= norm(qs[center]) 
	positions = pos(qg)
	(llink,rlink) = getlink(qs, positions)
	wires = IndexSet(getfree(qs,positions))
	net = ITensorNet(ITensor(qg,wires))
	for i ∈ positions
		push!(net, qs[i])
	end
	exact = noprime!(contractall(net))
	if range(qg) == 1 
		qs[pos(qg)[1]] = exact 
	else 
		approx = exact_MPS(exact, wires, llink, rlink; kwargs...)
		replace!(qs, approx, positions)
	end
	changelims!(qs,positions)
	return qs
end

function position!(qs::MPSState, j::Int) 
	psi = qs.s
	N = length(psi)

	while leftLim(psi) < (j-1)
		ll = leftLim(psi)+1
		s = findindex(psi[ll], "Site, s=$(ll)")#getfree(qs,ll)
		if ll == 1
	  		(Q,R) = qr(psi[ll],s)
		else
	  		li = linkindex(psi,ll-1)
	  		(Q,R) = qr(psi[ll],s,li)
		end
		Q = replacetags(Q, "u", "l=$(ll)")
		R = replacetags(R, "u", "l=$(ll)")
		psi[ll] = Q
		psi[ll+1] *= R
		psi.llim_ += 1
	end
	while rightLim(psi) > (j+1)
		rl = rightLim(psi)-1
		s  = findindex(psi[rl], "Site, s=$(rl)")
		if rl == N
	  		(Q,R) = qr(psi[rl],s)
		else
	  		ri = linkindex(psi,rl)
	  		(Q,R) = qr(psi[rl],s,ri)
		end
		Q = replacetags(Q, "u", "l=$(rl-1)")
		R = replacetags(R, "u", "l=$(rl-1)")
		psi[rl] = Q
		psi[rl-1] *= R
		psi.rlim_ -= 1
	end
	psi.llim_ = j-1
	psi.rlim_ = j+1
end

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
	center = optpos(l,r,pos)
	position!(qs,center)
	return center
end

function replace!(qs::MPSState,new::Vector{ITensor}, pos::Vector{Int})
	if length(new)!= length(pos)
		error("length of new MPS sites and pos should match\n") 
	end
	for i =1 : length(pos)
		qs[pos[i]] = new[i]
	end
end

function changelims!(qs::MPSState, pos::Vector{Int})
	sorted = sort(pos)
	sorted != pos && error("local gate not have ordered pos input\n")
	MPS(qs).llim_ = pos[1]-1
	MPS(qs).rlim_ = pos[length(pos)]+1
	return qs
end

