struct QCircuit
	initstate::QState
	currstate::QState
	gatelist::Vector{QGate}
	evalpos::Int
	outgoing:: Vector{Index}
	# poslist::Vector{Int}
end

function preprocess!(qc::QCircuit)::QCircuit 

end

function runcircuit!(qc::QCircuit)    

end 

function runcircuit!(qc::Qcircuit, step::Int)

end

function measure(qc::QCircuit, pos::Integer)

end

function connect!(qc::QCircuit)
	for ii = 1 to length(gatelist)
		
	end
end

