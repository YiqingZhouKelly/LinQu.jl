
# for repeated blocks in a circuit
struct QGateSet
	set::Vector{QGate}
	function QGateSet(gates::QGate...)
		set = QGate[]
		for gate ∈ gates
			push!(set, gate)
		end
		new(set)
	end
end #struct

getindex(gs::QGateSet, j::Int) = getindex(gq.set, j)
setindex!(gs::QGateSet, gate::QGate, j::Int) = setindex!(gs.set, gate,j)
length(qgset::QGateSet) = length(qgset.set)

push!(qgset::QGateSet, qg::QGate) = push!(qgset.set,qg)
function push!(set1::QGateSet, set2::QGateSet)
	for i = 1: length(set2)
		push!(set1, set2[i])
	end
end

# Support iteration
size(qgs::QGateSet) = size(qgs.set)
iterate(qgs::QGateSet,state::Int=1) = iterate(qgs.set,state)
#copy should not be needed