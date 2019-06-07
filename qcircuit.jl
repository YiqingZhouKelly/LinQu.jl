# using ITensors
include("./qstate.jl")
include("qgate.jl")
include("qgateset.jl")
struct QCircuit
	# initstate::QState
	state::QState
	gatelist::QGateSet
	evalpos::Int
	outgoing:: Vector{Index}
	# TODO: store truncation criterion
	# QCircuit(numqubits::Int) = new(MPSStates(numqubits),QGate[], 0, )
	function QCircuit(numqubits::Int)
		mps = MPSState(numqubits)
		outgoing = getfreelist(mps)
		new(mps,QGate[],0,outgoing) 
	end
	QCircuit(mps::MPSState) = new(mps,QGate[],0,getfreelist(mps))
end #struct
# push!(qc::QCircuit, obj) = push!(qc.gatelist,obj)
# addgate(qc::QCircuit, qg::QGate) = push!(qc,qg)


# function preprocess!(qc::QCircuit)::QCircuit 

# end

# function runcircuit!(qc::Qcircuit, step::Int)

# end

# function measure(qc::QCircuit, pos::Integer)

# end

# function connect!(qc::QCircuit)
# 	for ii = 1 to length(gatelist)
		
# 	end
# end

