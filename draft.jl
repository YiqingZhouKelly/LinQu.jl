import Base.length
struct IntSet
 set::Vector{Int}
 IntSet(data::Vector{Int}) = new(data)
end

length(s::IntSet) = length(s.set)
copy(s::IntSet) = copy.(s)
iterate(is::IntSet) = iterate(is.set)


s = IntSet([1,2,3,4])
print(copy(s))