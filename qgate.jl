
mutable struct QGate 
	data::Vector{T} where {T}
	qubits::Vector{Int}

	function QGate(data, qubits::Vector{Int})
		numQubits = Int(log2(length(data))/2)
		if numQubits != length(qubits)
			error("A $(numQubits) qubit gate should act on $(numQubits) sites!")
		end
		new(data,qubits)
	end
	QGate(data, qubits::T...) where {T <: Number} = QGate(data,[q for q ∈ qubits])
end # struct

qubits(gate::QGate) = gate.qubits
data(gate::QGate) = gate.data 

IGate(qubits::Vector{Int}) = QGate(complex([1,0,0,1]),qubits)
XGate(qubits::Vector{Int}) = QGate(complex([0,1,1,0]),qubits)
YGate(qubits::Vector{Int}) = QGate(complex([0,1im,-1im,0]),qubits)
ZGate(qubits::Vector{Int}) = QGate(complex([1,0,0,-1]),qubits)
TGate(qubits::Vector{Int}) = QGate(complex([1,0,0,exp(π/4im)]),qubits)
HGate(qubits::Vector{Int}) = QGate(complex((1/√2)*[1,1,1,-1]),qubits)
SGate(qubits::Vector{Int}) = QGate(complex([1,0,0,1im]),qubits)

IGate(qubits::Int...) = IGate([q for q ∈ qubits])
XGate(qubits::Int...) = XGate([q for q ∈ qubits])
YGate(qubits::Int...) = YGate([q for q ∈ qubits])
ZGate(qubits::Int...) = ZGate([q for q ∈ qubits])
TGate(qubits::Int...) = TGate([q for q ∈ qubits])
HGate(qubits::Int...) = HGate([q for q ∈ qubits])
SGate(qubits::Int...) = SGate([q for q ∈ qubits])

TdagGate(qubits::Vector{Int}) = QGate(complex([1,0,0,exp(-π/4im)]),qubits)
TdagGate(qubits::Int...) = TdagGate([q for q ∈ qubits])


function ToffoliGate(qubits::Vector{Int})
	toffoli = zeros(2,2,2,2,2,2)
	toffoli[1,1,1,1,1,1]=1
	toffoli[1,1,2,1,1,2]=1
	toffoli[1,2,1,1,2,1]=1
	toffoli[2,1,1,2,1,1]=1
	toffoli[2,2,1,2,2,2]=1
	toffoli[2,1,2,2,1,2]=1
	toffoli[1,2,2,1,2,2]=1
	toffoli[2,2,2,2,2,1]=1
	return QGate(toffoli, qubits)
end
function RxGate(θ, qubits::Vector{Int})
	θ = float(θ)
	c = cos(θ/2.)
	s = -1im*sim(θ/2.)
	QGate(complex([c,s,s,c]),qubits)
end

function RyGate(θ, qubits::Vector{Int})
	θ = float(θ)
	c = cos(θ/2)
	s = sin(θ/2)
	QGate([c,s,-s,c],qubits)
end

function RzGate(θ, qubits::Vector{Int})
	θ = float(θ)
	exponent_ = θ/2
	QGate([exp(-exponent_),0,0,exp(exponent_)],qubits)
end

SwapGate(qubits::Vector{Int}) = QGate(complex([1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1]),qubits)
SwapGate(qubits::Int...) = SwapGate([q for q ∈ qubits])
CNOTGate(qubits::Vector{Int}) = QGate(complex([1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0]),qubits)
CNOTGate(qubits::Int...) = CNOTGate([q for q ∈ qubits])

ITensor(gate::QGate, inds::IndexSet) = ITensor(gate_tensor(gate), IndexSet(inds,prime(inds)))
ITensor(gate::QGate, ind::Index...) = ITensor(gate, IndexSet(ind...))