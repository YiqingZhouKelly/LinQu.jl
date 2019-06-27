
mutable struct VarGateShell
	f::Function
	qubits::Vector{Int}
	name::String
	VarGateShell(f::Function, 
				 qubits::Vector{Int},
				 name::String = "") = new(f, qubits, name)
	VarGateShell(f::Function, 
				 qubits::Vector{Int},
				 name::String = "") = new(f, [qubits...], name)
end


qubits(shell::VarGateShell) = shell.qubits
func(shell::VarGateShell) = shell.f
name(shell::VarGateShell) = shell.name
copy(shell::VarGateShell) = VarGateShell(f, copy(qubits), name)