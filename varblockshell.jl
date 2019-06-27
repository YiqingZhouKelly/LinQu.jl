struct VarBlockShell
	gates::Vector{T} where {T <: Union{VarGateShell, ConstGate, ControlledGate}}
	param::Vector{Real}
end