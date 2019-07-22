
# tuple 
(kernel::GateKernel)(qubits::Int...) = QGate(kernel)(qubits...)
(gate::VarGate)(qubit::Int...) = (gate, ActPosition([qubit...]))
(block::QGateBlock)(qubit::Int...) = (block, ActPosition([qubit...]))
getindex(kernel::GateKernel, param...) = VarGate(kernel, [param...])
getindex(gate::VarGate, params...) = (gate.param = [params...]; return gate)
(gate::ConstGate)(qubit::Int...) = (gate, ActPosition([qubit...])) 

#array
(kernel::GateKernel)(qubits::Vector{Int}) = QGate(kernel)(qubits)
(gate::VarGate)(qubit::Vector{Int}) = (gate, ActPosition(qubit))
(block::QGateBlock)(qubit::Vector{Int}) = (block, ActPosition(qubit))
getindex(kernel::GateKernel, param::Vector) = VarGate(kernel, param)
getindex(gate::VarGate, params::Vector) = (gate.param = params; return gate)
(gate::ConstGate)(qubit::Vector{Int}) = (gate, ActPosition(qubit))

