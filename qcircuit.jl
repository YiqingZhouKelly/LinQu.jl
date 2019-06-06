include("./qstate.jl")
include(".qgate.jl")
struct QCircuit
	# initstate::QState
	state::QState
	gatelist::Vector{(Vector{Number},Vector{Number})}
	evalpos::Int
	outgoing:: Vector{Index}
	# QCircuit(numqubits::Int) = new(MPSStates(numqubits),QGate[], 0, )
	function QCircuit(numqubits::Int)
		mps = MPSState(numqubits)
		outgoing = getfreelist(mps)
		new(mps,QGate[],0,outgoing) 
	end
	QCircuit(mps::MPSState) = new(mps,QGate[],0,getfreelist(mps))

end

function addgate(qc::QCircuit, gate::Vector{Number}, pos::Vector{Int})
	push!(qc.gatelist,(gate,pos))
end

function applygate!(qs::MPSState,qg::QGate)
	center = movegauge!(qs,pos(qg))
	net = ITensor[]
end

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

