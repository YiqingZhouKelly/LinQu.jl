
struct QGateSet
	set::Vector{QGate}

	QGateSet() = new(QGate[])
	QGateSet(gates::Vector{QGate}) = new(gates)
	QGateSet(gates::QGate...) = QGateSet(_tuple_array(gates))
end #struct

getindex(gs::QGateSet, j::Int) = getindex(gs.set, j)
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
QGate(qgs::QGateSet) = length(qgs)==1 ? qgs[1] : error("Cannot convert QGateSet of length >1 to a QGate\n")

function applylocalgate!(qs::MPSState, qg::QGateSet; kwargs...) 
	# TODO: Need to define iterate() for QGateSet, not tested
	for gate ∈ qgate
		applylocalgate!(qs,gate;kwargs...)
	end
	return qs
end