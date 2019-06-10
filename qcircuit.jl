
mutable struct QCircuit
	state::QState
	gates::QGateSet
	evalpos::Int
	outgoing:: Vector{Index}
	# TODO: store truncation criterion
	function QCircuit(N::Int)
		mps = MPSState(N)
		outgoing = getfreelist(mps)
		new(mps,QGate[],0,outgoing) 
	end
	QCircuit(mps::MPSState) = new(mps,QGate[],0,getfreelist(mps))
end #struct

gates(qc::QCircuit) = qc.gates
state(qc::QCircuit) = qc.state
push!(qc:: QCircuit, qg::QGate) = push!(gates(qc), qg)
# iterate(qc::QCircuit,state::Int=1) = iterate(qc.gates,state)
# size(qc::QCircuit) = size(QGateSet)


function localize(qc::QCircuit)
	localized = QGateSet()
	for gate ∈ gates(qc)
		if checklocal(gate)
			push!(localized, gate)
		else
			push!(localized, nonlocal_local(gate))
		end
	end
	return localized
end

function minswap(qc::QCircuit)
	optimized = [IGate(1)] # TODO: may be better way 
	for curr ∈ gates(qc)
		prev = pop!(optimized)
		if !repeatedswap(prev, curr)
			push!(optimized, prev)
			push!(optimized, curr)
		end
	end
	return optimized
end