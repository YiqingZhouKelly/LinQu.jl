
# tuple 
(kernel::GateKernel)(qubits::Int...) = QGate(kernel)(qubits...)
(gate::QGate)(qubit::Int...) = (gate, [qubit...])
(block::QGateBlock)(qubit::Int...) = (block,[qubit...])
getindex(kernel::GateKernel, param...) = VarGate(kernel, [param...])
getindex(gate::VarGate, params...) = (gate.param = [params...]; return gate)

#array
(kernel::GateKernel)(qubits::Vector{Int}) = QGate(kernel)(qubits)
(gate::QGate)(qubit::Vector{Int}) = (gate, qubit)
(block::QGateBlock)(qubit::Vector{Int}) = (block, qubit)
getindex(kernel::GateKernel, param::Vector) = VarGate(kernel, param)
getindex(gate::VarGate, params::Vector) = (gate.param = params; return gate)

apply!(state::QState, tup:: Tuple{Union{QGate, QGateBlock}, Vector{Int}} ; kwargs...) = apply!(state, tup[1], tup[2]; kwargs...)

function measure!(state::QState; kwargs...)
	qubits = get(kwargs, :qubits, nothing)
	qubit = get(kwargs, :qubit, nothing)

	shots = get(kwargs, :shots, 1024)
	if qubits ==nothing
		qubit == nothing && (throw(ArgumentError("Qubit(s) to be measured not specified")))
		return measure!(state, qubits, shots; kwargs...)
	else
		qubit != nothing && (throw(ArgumentError("Both qubits and qubit are specified")))
		return measure!(state, qubit, shots; kwargs...)
	end
end

randomQCircuit(;size::Int, depth::Int = rand(1:10)) = QCircuit(randomQGateBlock(size,depth), size)