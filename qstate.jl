using ITensors
include("./helper.jl")
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

# == helpers that should not belong here == 
function noprime!(A::ITensor)
	""" set prime level of all Indices connected to A to 0"""
	noprime!(IndexSet(A))
	A
end 
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

leftLim(m::MPSState) = leftLim(m.s)
rightLim(m::MPSState) = rightLim(m.s)


# print("\n===test contract===\n")
# inds = Index[]
# for i =1:2
# 	push!(inds,Index(2))
# end
# A = randomITensor(Float64,inds)
# print(A)
# U,S,V,u,v = svd(A,inds[1])
# print(contractall(U,S,V))	
# print("\n====end=====\n")


# struct MixedState <: QState
# 	s::MPS
# end 

# struct ExactState <: QState
# 	s:: MPS
# end 

# ===== mini test ====
# initstate = rand(Float64,2)
# initstate/=norm(initstate)
# # print("norm = ", norm(initstate))
# m = MPSState(3,initstate)
# print(m)
# print("\nthe free in dex at pos 1:\n")
# print(getfree(m,2))
inds = Index[]

for i =1:4
	push!(inds,Index(2))
end
A = randomITensor(Float64,inds)
B = exact_MPS(A,inds)
print(B)


