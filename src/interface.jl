
# tuple 
(kernel::GateKernel)(qubits::Int...) = QGate(kernel)(qubits...)
(gate::VarGate)(qubit::Int...) = (gate, [qubit...])
(block::QGateBlock)(qubit::Int...) = (block,[qubit...])
getindex(kernel::GateKernel, param...) = VarGate(kernel, [param...])
getindex(gate::VarGate, params...) = (gate.param = [params...]; return gate)
(gate::ConstGate)(qubit::Int...) = (gate, [qubit...]) 

#array
(kernel::GateKernel)(qubits::Vector{Int}) = QGate(kernel)(qubits)
(gate::VarGate)(qubit::Vector{Int}) = (gate, qubit)
(block::QGateBlock)(qubit::Vector{Int}) = (block, qubit)
getindex(kernel::GateKernel, param::Vector) = VarGate(kernel, param)
getindex(gate::VarGate, params::Vector) = (gate.param = params; return gate)
(gate::ConstGate)(qubit::Vector{Int}) = (gate, qubit)

apply!(state::QState, tup:: Tuple{Union{QGate, QGateBlock}, Vector{Int}} ; kwargs...) = apply!(state, tup[1], tup[2]; kwargs...)