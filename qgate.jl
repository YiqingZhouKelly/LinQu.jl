
mutable struct QGate 
	data::Vector{Float64} 
	pos::Vector{Int}
	function QGate(data,pos::Vector{Int}) #TODO: data specified as Vector{Number} breaks the code
		numqubit = Int(log2(length(data))/2)
		if numqubit != length(pos)
			error("A $(numqubit) qubit gate should act on $(numqubit) sites!")
		end
		new(data,pos)
	end
	QGate(data, pos::Int...) = QGate(data,_tuple_array(pos))
end # struct

pos(g::QGate) = g.pos
range(g::QGate) = length(g.pos)
gate_tensor(g::QGate) = g.data
copy(qg::QGate) = QGate(copy(gate_tensor(qg)), copy(pos(qg)))

function checklocal(pos::Vector{Int})
	length(pos) == 1 && return true
	sorted = sort(pos)
	for i =2:length(pos)
		(sorted[i] != sorted[i-1]+1) && (return false)
	end
	return true
end
checklocal(qg::QGate) = checklocal(pos(qg))

function nonlocal_local(qg::QGate) #:: QGateSet
	#TODO : Could do optimization here
	position = pos(qg)
	if length(position)>2
		error("currently only support 2 qubit gates\n")
	end
	localgates = QGate[]
	left = min(position...)
	right = max(position...)
	#TODO: Now assume always move to the first index 
	while right > left+1
		push!(localgates, SwapGate(right-1, right))
		right-=1
	end
	if position[1]>position[2] # control to the right of target
		push!(localgates, SwapGate(left, right))
	end
	swapback = reverse(localgates)
	localqg = movegate(qg,left, right)
	push!(localgates,localqg)
	localgates = vcat(localgates, swapback)
	return QGateSet(localgates)
end

function movegate!(qg::QGate, p::Vector{Int})
	if length(p) != range(qg)
		error(" Got wron gnumber of qubits to act on\n")
	end
	qg.pos = p
	return qg
end
movegate!(qg::QGate, p::Int...) = movegate!(qg, _tuple_array(p))
movegate(qg::QGate, p::Vector{Int}) = movegate!(copy(qg), p)
movegate(qg::QGate, p::Int...)= movegate!(copy(qg), p...)

# == sigle quibit gates == 
IGate(pos::Vector{Int}) = QGate([1.,0.,0.,1.],pos)
XGate(pos::Vector{Int}) = QGate([0.,1.,1.,0.],pos)
YGate(pos::Vector{Int}) = QGate([0.,-1.0im, 1.0im, 0.],pos)
ZGate(pos::Vector{Int}) = QGate([1.,0.,0.,-1.],pos)
TGate(pos::Vector{Int}) = QGate([1.,0.,0.,exp(-1im*π/4)],pos)
HGate(pos::Vector{Int}) = QGate((1/√2)*[1,1,1,-1],pos) # H could be decomposed in to XY / YZ gates
SGate(pos::Vector{Int}) = QGate([1.,0.,0.,1.0im],pos)

IGate(pos::Int...) = IGate(_tuple_array(pos))
XGate(pos::Int...) = XGate(_tuple_array(pos))
YGate(pos::Int...) = YGate(_tuple_array(pos))
ZGate(pos::Int...) = ZGate(_tuple_array(pos))
TGate(pos::Int...) = TGate(_tuple_array(pos))
HGate(pos::Int...) = HGate(_tuple_array(pos)) # H could be decomposed in to XY / YZ gates
SGate(pos::Int...) = SGate(_tuple_array(pos))



function Rx(θ::Number, pos::Vector{Int})
	c = cos(θ/2.)
	s = -1.0im*sim(θ/2.)
	QGate([c,s,s,c],pos)
end

function Ry(θ::Number, pos::Vector{Int})
	c = cos(θ/2.)
	s = sin(θ/2.)
	QGate([c,-s,s,c],pos)
end

function Rz(θ::Number, pos::Vector{Int})
	exponent_ = θ/2.
	QGate([exp(-exponent_),0.,0.,exp(exponent_)],pos)
end

Rx(θ::Number, pos::Int...) = Rx(θ, _tuple_array(pos))
Ry(θ::Number, pos::Int...) = Ry(θ, _tuple_array(pos))
Rz(θ::Number, pos::Int...) = Rz(θ, _tuple_array(pos))

# == two qubit gates ==
SwapGate(pos::Vector{Int}) = QGate([1.,0.,0.,0.,
									0.,0.,1.,0.,
									0.,1.,0.,0.,
									0.,0.,0.,1.],pos)
SwapGate(pos::Int...) = SwapGate(_tuple_array(pos))
CNOTGate(pos::Vector{Int}) = QGate([1.,0.,0.,0.,
								    0.,1.,0.,0.,
								    0.,0.,0.,1.,
								    0.,0.,1.,0.],pos)
CNOTGate(pos::Int...) = CNOTGate(_tuple_array(pos))
# CZGate() = QGate(Diagonal([1.,1.,1.,-1.]),2) # TODO: check diagonal working??
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
ITensor(qg::QGate, inds::IndexSet) = ITensor(gate_tensor(qg), IndexSet(inds,prime(inds)))
ITensor(qg::QGate, ind::Index...) = ITensor(qg, IndexSet(_tuple_array(ind)))
isswap(qg::QGate) = (gate_tensor(qg)== [1.,0.,0.,0.,
										0.,0.,1.,0.,
										0.,1.,0.,0.,
										0.,0.,0.,1.])
sameposition(A::QGate, B::QGate) = (sort(pos(A)) == sort(pos(B)))
repeatedswap(A::QGate, B::QGate) = (isswap(A) && isswap(B) && sameposition(A,B))


