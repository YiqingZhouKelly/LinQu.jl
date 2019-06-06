include("./qstate.jl")
include(".qgate.jl")
struct QCircuit
	# initstate::QState
	state::QState
	gatelist::Vector{(Vector{Number},Vector{Number})}
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

function addgate(qc::QCircuit, gate::Vector{Number}, pos::Vector{Int})
	push!(qc.gatelist,(gate,pos))
end

function applylocalgate!(qs::MPSState,qg::QGate; kwargs...)
	center = movegauge!(qs,pos(qg))
	llink,rlink = getfree(qs, pos(qg))
	wires = IndexSet(getfree(qs,pos(qg)))
	net = ITensorNet(qgate_itensor(qg,wires))
	for i =1:length(pos(qg))
		push!(net,qs[i])
	end
	exact = noprime!(contractall(net))
	approx = exact_MPS(exact, wires, llink, rlink; kwargs...)
	replace!(qs, approx, pos(qg))
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

