

(kernel::GateKernel)(qubits::Int...) = VarGate(kernel)(qubits...)
(gate::VarGate)(qubit::Int...) = (gate, ActPosition([qubit...]))
(block::QGateBlock)(qubit::Int...) = (block, ActPosition([qubit...]))
getindex(kernel::GateKernel, param...) = VarGate(kernel, [param...])
getindex(kernel::GateKernel, param::Vector{T} where {T}) = VarGate(kernel, param)
getindex(gate::VarGate, params...) = (gate.param = [params...]; return gate)
getindex(gate::VarGate, params::Vector{T} where {T}) = (gate.param = params; return gate)
(gate::ConstGate)(qubit::Int...) = (gate, ActPosition([qubit...])) # used as input arg in add!
