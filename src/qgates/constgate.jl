
mutable struct ConstGate <: QGate
	kernel::GateKernel
	ConstGate(kernel::GateKernel) = new(kernel)
end #struct

function ConstGate(data::Vector{T} where {T<:Number}, name::String="Anonymous")
	f() = data
	kernel = GateKernel(f, name)
	return ConstGate(kernel)
end

ConstGate(f::Function, name::String="Anonymous") = ConstGate(GateKernel(f, name))

function ConstGate(; kwargs...)
	f = get(kwargs, :f, error("function must be defined"))
	name = get(kwargs, :name, "anonymous const gate")
	return ConstGate(f, name)
end

name(gate::ConstGate) = name(gate.kernel)
data(gate::ConstGate) = func(gate)()
func(gate::ConstGate) = func(gate.kernel)

copy(gate::ConstGate) = gate
==(gate1::ConstGate, gate2::ConstGate) = (gate1.kernel == gate2.kernel)
control(gate::ConstGate) = ConstGate(control(gate.kernel))

function show(io::IO, gate::ConstGate)
	printstyled(io, name(gate); bold=true, color= :blue)
end

inverse(gate::ConstGate) = ConstGate(inverse(gate.kernel))
function randomConstGate(n::Int=rand(1:3))
	if n==1
		choices = [X,Y,Z,H,T,TDAG,S,SDAG]
	elseif n==2
		choices = [CNOT, SWAP]
	else 
		choices = [TOFFOLI, FREDKIN]
	end
	count = length(choices)
	return choices[rand(1:count)]
end