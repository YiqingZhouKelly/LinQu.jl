using ITensors
import ITensors.linkind,
	   ITensors.getindex,
	   Base.length,
	   Base.copy,
	   ITensors.noprime!
# Move to a module later...

abstract type QState end

# error check no valid subclass function fits the call

struct MPSState <: QState
	s::MPS
	freelist:: Vector{Index} #?? is it really needed

	# MPSState() = new(MPS())

	function MPSState(N::Int, init::Vector{T}) where {T}
		linklist = Index[]
		freelist = Index[]
		itensorlist = ITensor[]
		# if length(init)!=2
		# 	error("init dim error")
		# end
		# if norm(init)!== 1.0 
		# 	error("init wrong norm",norm(init)) #?? comparison not working as expected
		# end
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
		m = MPS(N,itensorlist,0,N+1)
		new(m,freelist)
	end

	MPSState(N::Int) = MPSState(N,[1.,0.]) #initialize to |0> state
end #struct

# getindex(st::MPSState,n::Int) = getindex(st.s,n)
# setindex!(st::MPSState,T::ITensor,n::Integer) = setindex!(st.s,T,n)

length(m::MPSState) = length(m.s)

# copy(st::MPSState) = MPSState(copy(st.s), ) # Need to think about how to get the free list...
getfreelist(m::MPSState) = m.freelist
getfree(m::MPSState,j::Int) = getindex(m.freelist,j)

function noprime!(A::ITensor)
	noprime!(IndexSet(A))
	A
end

function applygate!(qs::MPSState, gate::Tuple{Vector{Float64},Vector{Int}})
	data,pos = gate
	freeinds = IndexSet([getfree(qs,ii) for ii ∈ pos])
	print("inds:", inds)
	product = ITensor(data,IndexSet(freeinds,prime(freeinds)))
	print("good so far")
	for ii ∈ pos
		product*=qs.s[ii]
	end
	noprime!(product)
end	

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


