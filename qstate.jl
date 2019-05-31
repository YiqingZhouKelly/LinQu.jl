using ITensors
import ITensors.linkind,
	   ITensors.getindex
	   ITensors.all


abstract type QState end

# error check no valid subclass function fits the call

struct MPSState <: QState
	s::MPS

	MPSState() = new(MPS())
	# # MPSState(N::Int) = new(MPS(spinHalfSites(N)))
	# MPSState(N::Int) = new(MPS(Int, InitState(spinHalfSites(N), 1)))
	function MPSState(N::Int) 
		m = MPS(spinHalfSites(N))
		for i = 1:N
			fill!(m[i],1.0)
			m[i]/=norm(m[i])
		end
		new(m)
	end
end #struct

getindex(st::MPSState,n::Int) = getindex(st.s,n)
setindex!(st::MPSState,T::ITensor,n::Integer) = setindex!(st.s,T,n)
length(m::MPSState) = m.s.N_
copy(st::MPSState) = copy(st.s)


function freeind(st::MPSState,j::Integer)
	link =[]
	if j<length(st)
		push!(link,linkind(st.s,j)) #linkind not exported
	end
	if j>1
		push!(link,linkind(st.s,j-1))
	end
	# print("get diff")
	setdiff(inds(getindex(st,j)), link)
end 



# struct MixedState <: QState
# 	s::MPS
# end 

# struct ExactState <: QState
# 	s:: MPS
# end 

# ===== mini test ====
st = MPSState(3)
print(st)
print(freeind(st,1))