
struct GateType
	f::Function
	GateType(f::Function) = new(f)
end #struct
(type::GateType)(qubits::Vector{Int},param::Vector{T} where {T<:Real} = Real[]) = QGate(type, qubits, param)
