# using ITensors,LinearAlgebra, Statistics
struct QGate 
	data::Vector{Float64} 
	pos::Vector{Int}
	function QGate(data,pos::Vector{Int}) #TODO: data specified as Vector{NUmber} breaks the code
		numqubit = Int(log2(length(data))/2)
		if numqubit != length(pos)
			error("A $(numqubit) qubit gate should act on $(numqubit) sites!")
		end
		new(data,pos)
	end
	function QGate(data, pos::Int...)
		positinarr = Int[]
		for i in pos
			push!(positinarr, i)
		end
		QGate(data, positinarr)
	end
end
pos(g::QGate) = g.pos
range(g::QGate) = length(g.pos)
gate_tensor(g::QGate) = g.data
# == sigle quibit gates == 
IGate(pos::Vector{Int}) = QGate([1.,0.,0.,1.],pos)
XGate(pos::Vector{Int}) = QGate([0.,1.,1.,0.],pos)
YGate(pos::Vector{Int}) = QGate([0.,-1.0im, 1.0im, 0.],pos)
ZGate(pos::Vector{Int}) = QGate([1.,0.,0.,-1.],pos)
TGate(pos::Vector{Int}) = QGate([1.,0.,0.,exp(-1im*π/4)],pos)
HGate(pos::Vector{Int}) = QGate((1/√2)*[1,1,1,-1],pos) # H could be decomposed in to XY / YZ gates
SGate(pos::Vector{Int}) = QGate([1.,0.,0.,1.0im],pos)

IGate(pos::Int...) = QGate([1.,0.,0.,1.],_tuple_array(pos))
XGate(pos::Int...) = QGate([0.,1.,1.,0.],_tuple_array(pos))
YGate(pos::Int...) = QGate([0.,-1.0im, 1.0im, 0.],_tuple_array(pos))
ZGate(pos::Int...) = QGate([1.,0.,0.,-1.],_tuple_array(pos))
TGate(pos::Int...) = QGate([1.,0.,0.,exp(-1im*π/4)],_tuple_array(pos))
HGate(pos::Int...) = QGate((1/√2)*[1,1,1,-1],_tuple_array(pos)) # H could be decomposed in to XY / YZ gates
SGate(pos::Int...) = QGate([1.,0.,0.,1.0im],_tuple_array(pos))

function _tuple_array(T)
	Tarr = [t for t in T]
	return Tarr
end

# function Rx(θ::Number)
# 	c = cos(θ/2.)
# 	s = -1.0im*sim(θ/2.)
# 	QGate([c,s,s,c],1)
# end

# function Ry(θ::Number)
# 	c = cos(θ/2.)
# 	s = sin(θ/2.)
# 	QGate([c,-s,s,c],1)
# end

# function Rz(θ::Number)
# 	exponent_ = θ/2.
# 	QGate([exp(-exponent_),0.,0.,exp(exponent_)],1)
# end


# # == two qubit gates ==
# SwapGate() = QGate([1.,0.,0.,0.,
# 				    0.,0.,1.,0.,
# 				    0.,1.,0.,0.,
# 				    0.,0.,0.,1.],2)
# CNOTGate() = QGate([1.,0.,0.,0.,
# 				    0.,1.,0.,0.,
# 				    0.,0.,0.,1.,
# 				    0.,0.,1.,0.],2)
# CZGate() = QGate(Diagonal([1.,1.,1.,-1.]),2) #check diagonal working??
# CRGate(θ::Number) = QGate(Diagonal([1.,1.,1.,exp(1.0im*θ))]),2)
# CRkGate(k::Number) = CRGate()

# # Toffoli 
# function ToffoliGate()
# 	mat = diagm(0 =>push!(ones(6),0.,0.))
# 	mat[7,8] = 1.
# 	mat[8,7] = 1.
# 	QGate(mat, 3)
# end

# === new added====
qgate_itensor(qg::QGate, inds::IndexSet) = ITensor(gate_tensor(qg), IndexSet(inds,prime(inds)))



