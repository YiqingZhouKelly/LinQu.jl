# some extensions to ITensors.jl

getindex(T::ITensor, pairs::Tuple{Index, Int}...) = getindex(T, [IndexVal(pair...) for pair ∈ pairs]...)
getindex(T::ITensor, pairs::Vector{Tuple{Index, Int}}) = getindex(T, pairs...)

function contract(A::ITensor, B::ITensor, i::Index, j::Index)
	@assert hasindex(IndexSet(A),i)
	@assert hasindex(IndexSet(B),j)
	@assert dim(i) == dim(j)
	pos_i = 1
	pos_j = 1
	while IndexSet(A)[pos_i]!= i
		pos_i+=1
	end
	while IndexSet(B)[pos_j]!= j
		pos_j+=1
	end
	A.inds[pos_i] = j
	C = A*B
	A.inds[pos_i] = i
	return C
end

function clamp(A::ITensor, ind::Index, j::Int)
	v = zeros(dim(ind))
	v[j] = 1.0
	projector = ITensor(v, ind)
	return A*projector
end