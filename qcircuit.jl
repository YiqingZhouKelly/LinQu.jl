
mutable struct QCircuit
	state::QState
	gates::QGateSet
	evalpos::Int
	# TODO: store truncation criterion
	function QCircuit(N::Int)
		mps = MPSState(N)
		new(mps,QGateSet(),0) 
	end
	QCircuit(mps::MPSState) = new(mps,QGateSet(),0)
end #struct

gates(qc::QCircuit) = qc.gates
state(qc::QCircuit) = qc.state
push!(qc:: QCircuit, qg::QGate) = push!(gates(qc), qg)
# iterate(qc::QCircuit,state::Int=1) = iterate(qc.gates,state)
# size(qc::QCircuit) = size(QGateSet)
function runlocal!(qc::QCircuit)
	for gate ∈ gates(qc)
		# if range(gate) ==1
		# 	applysinglegate!(qc.state, gate)
		# else
			applylocalgate!(qc.state, gate)
		# end
		print("\n>>>>>>>>>>",qc)
		qc.evalpos+=1
	end
end
function localize(qc::QCircuit) #::QGateSet
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
function localize!(qc::QCircuit)
	qc.gates = localize(qc)
	return qc
end

function minswap(qc::QCircuit)
	# TODO: Currenly using a sentinel
	optimized = [IGate(1)] 
	for curr ∈ gates(qc)
		prev = pop!(optimized)
		if !repeatedswap(prev, curr)
			push!(optimized, prev)
			push!(optimized, curr)
		end
	end
	return QGateSet(optimized)
end

function minswap!(qc::QCircuit)
	qc.gates = minswap(qc)
	return qc
end

minswap_localize!(qc::QCircuit) = minswap!(localize!(qc))

function show(io::IO, qc::QCircuit)
	print("-------\n")
	print("|State|\n")
	print("-------\n")
	print(io,"=====================\n")
	print(io,state(qc),"\n")
	print("-------\n")
	print("|Gates|\n")
	print("-------\n")
	for gate ∈ gates(qc)
		print(io,gate,"\n")
	end
	print(io,"=====================\n")
end

function cleargates!(qc::QCircuit)
	qc.gates = QGateSet()
	return qc
end