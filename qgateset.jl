
# for repeated blocks in a circuit
struct QGateSet
	set::Vector{QGate}
end #struct

length(qgset::QGateSet) = length(qgset.set)
push!(qgset::QGateSet, qg::QGate) = push!(qgset.set,qg)
function push!(set1::QGateSet, set2::QGateSet)
	for i = 1: length(set2)
		push!(set1, set2[i])
	end
end
#copy should not be needed