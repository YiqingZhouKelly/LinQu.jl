mutable struct VarGate
	id::Int
	qubits::Vector{Int}
	θ::T where {T<:Real}
	VarGate(id::Int, 
			qubits::Tuple{Vector{Int}}, 
			θ::T where {T<: Real}) = new(id, qubits[1], θ)

	VarGate(is::Int, 
			qubits::NTuple{S, Int} where {S},
			θ:: T where {T<: Real}) = new(is,[qubits...], θ)
end

qubits(gate::VarGate) = gate.qubits
id(gate::VarGate) = gate.id
θ(gate::VarGate) = gate.θ
copy(gate::VarGate) = ConstGate(id(gate), copy(qubits(gate)), θ(gate))

function data(gate::VarGate)
	if id(gate) == 1 #Rx
		return cos(θ(gate)/2)I_DATA - sin(θ(gate)/2)im* X_DATA
	elseif id(gate) == 2 #Ry
		return cos(θ(gate)/2)I_DATA - sin(θ(gate)/2)im* Y_DATA
	elseif id(gate) == 3 #Rz
		return cos(θ(gate)/2)I_DATA - sin(θ(gate)/2)im* Z_DATA
	else # id(gate) == 4 #Rϕ
		phaseGate = zeros(2,2)
		phaseGate[1,1] = 1
		phaseGate[2,2] = exp(θ(gate)im)
		return phaseGate
	end
end

Rx(θ::T where {T<: Real}, qubits::Location...) = VarGate(1,qubits, θ)
Ry(θ::T where {T<: Real}, qubits::Location...) = VarGate(2,qubits, θ)
Rz(θ::T where {T<: Real}, qubits::Location...) = VarGate(3,qubits, θ)
Rϕ(θ::T where {T<: Real}, qubits::Location...) = VarGate(4,qubits, θ)

ITensor(gate::VarGate, inds::IndexSet) = ITensor(data(gate), inds)
ITensor(gate::VarGate, ind::Index...) = ITensor(data(gate), ind...)

function show(io::IO, gate::VarGate)
	if id(gate) == 1 
		print("Rx, θ=$(θ(gate)), $(qubits(gate))\n")
	elseif id(gate) == 2
		print("Ry, θ=$(θ(gate)), $(qubits(gate))\n")
	elseif id(gate) == 3
		print("Rz, θ=$(θ(gate)), $(qubits(gate))\n")
	else 
		print("Rϕ, θ=$(θ(gate)), $(qubits(gate))\n")	
	end	
end
