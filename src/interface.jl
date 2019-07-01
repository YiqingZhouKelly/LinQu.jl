

(kernel::GateKernel)(qubits::Int...) = VarGate(kernel)(qubits...)
(gate::VarGate)(qubit::Int...) = (gate, ActPosition([qubit...]))
(block::QGateBlock)(qubit::Int...) = (block, ActPosition([qubit...]))
getindex(kernel::GateKernel, param::Real...) = VarGate(kernel, [param...])
getindex(kernel::GateKernel, param::Vector{T} where {T<:Real}) = VarGate(kernel, param)
(gate::ConstGate)(qubit::Int...) = (gate, ActPosition([qubit...])) # used as input arg in addGate!
