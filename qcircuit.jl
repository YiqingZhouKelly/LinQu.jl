struct QCircuit
	initstate::QState
	gatelist::Vector{QGate}
	poslist::Vector{Int}
end

function preprocess!(qc::QCircuit)

end

function runCircuit(qc::QCircuit)::Qstate 

end 

function measure(qc::QCircuit, pos::Integer)

end