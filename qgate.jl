using ITensors,LinearAlgebra, Statistics
struct QGate 
	data::Vector{Number} 
	pos::Vector{Int}
	QGate(data::Vector{Number},pos::Vector{Int}) = new()
end
pos(g::QGate) = g.pos
range(g::QGate) = length(g.pos)
gatematrix(g::QGate) = g.data
# == sigle quibit gates == 
IGate() = QGate([1.,0.,0.,1.],1)
XGate() = QGate([0.,1.,1.,0.],1)
YGate() = QGate([0.,-1.0im, 1.0im, 0.],1)
ZGate() = QGate([1.,0.,0.,-1.],1)
TGate() = QGate([1.,0.,0.,exp(-1im*π/4)],1)
HGate() = QGate((1/√2)*[1,1,1,-1],1) # H could be decomposed in to XY / YZ gates
SGate() = QGate([1.,0.,0.,1.0im],1)
function Rx(θ::Number)
	c = cos(θ/2.)
	s = -1.0im*sim(θ/2.)
	QGate([c,s,s,c],1)
end

function Ry(θ::Number)
	c = cos(θ/2.)
	s = sin(θ/2.)
	QGate([c,-s,s,c],1)
end

function Rz(θ::Number)
	exponent_ = θ/2.
	QGate([exp(-exponent_),0.,0.,exp(exponent_)],1)
end


# == two qubit gates ==
SwapGate() = QGate([1.,0.,0.,0.,
				    0.,0.,1.,0.,
				    0.,1.,0.,0.,
				    0.,0.,0.,1.],2)
CNOTGate() = QGate([1.,0.,0.,0.,
				    0.,1.,0.,0.,
				    0.,0.,0.,1.,
				    0.,0.,1.,0.],2)
CZGate() = QGate(Diagonal([1.,1.,1.,-1.]),2) #check diagonal working??
CRGate(θ::Number) = QGate(Diagonal([1.,1.,1.,exp(1.0im*θ))]),2)
CRkGate(k::Number) = CRGate()

# Toffoli 
function ToffoliGate()
	mat = diagm(0 =>push!(ones(6),0.,0.))
	mat[7,8] = 1.
	mat[8,7] = 1.
	QGate(mat, 3)
end

# === new added====
qgate_itensor(qg::QGate, inds::IndexSet) = ITensor(qg.data, IndexSet(inds,prime(inds)))



