struct VarGate
	id::Int
	qubits::Vector{Int}
	θ::Float64
	VarGate(id::Int, 
			qubits::Tuple{Vector{Int}}, 
			θ::IntFloat) = new(id, qubits[1], Float64(θ))

	VarGate(is::Int, 
			qubits::NTuple{T, Int} where {T},
			θ:: IntFloat) = new(is,[qubits...], Float64(θ))
end

qubits(gate::VarGate) = gate.qubits
id(gate::VarGate) = gate.id
θ(gate::VarGate) = gate.θ
function data(gate::VarGate)
	if id(gate) == 1 #Rx
		return cos(θ(gate)/2)I_DATA - sin(θ(gate)/2)im* X_DATA
	elseif id(gate) == 2 #Ry
		return cos(θ(gate)/2)I_DATA - sin(θ(gate)/2)im* Y_DATA
	elseif id(gate) == 3 #Rz
		return cos(θ(gate)/2)I_DATA - sin(θ(gate)/2)im* Z_DATA
	elseif id(gate) == 4 #Rϕ
		phaseGate = zeros(2,2)
		phaseGate[1,1] = 1
		phaseGate[2,2] = exp(θ(gate)im)
		return phaseGate
	end
end

Rx(θ::IntFloat, qubits::Location...) = VarGate(1,qubits, θ)
Ry(θ::IntFloat, qubits::Location...) = VarGate(2,qubits, θ)
Rz(θ::IntFloat, qubits::Location...) = VarGate(3,qubits, θ)
Rϕ(θ::IntFloat, qubits::Location...) = VarGate(4,qubits, θ)

ITensor(gate::VarGate, inds::IndexSet) = ITensor(data(gate), inds)
ITensor(gate::VarGate, ind::Index...) = ITensor(data(gate), ind...)