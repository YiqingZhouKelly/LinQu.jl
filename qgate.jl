using ITensors
struct QGate 
	gate::ITensor
	pos::Vector{Int}
end

SingleQubitGate(array::Vector{Number},pos) = QGate(ITensor(array, Index(2), Index(2)),pos)
IGate(pos::Vector{Int}) = SingleQubitGate([1.,0.,0.,1.],pos)
XGate(pos::Vector{Int}) = SingleQubitGate([0.,1.,1.,0.],pos)
YGate(pos::Vector{Int}) = SingleQubitGate([0.,-1.0im, 1.0im, 0.],pos)
ZGate(pos::Vector{Int}) = SingleQubitGate([1.,0.,0.,-1.],pos)
TGate(pos::Vector{Int}) = SingleQubitGate([1.,0.,0.,exp(-1im*π/4)], pos)

IGate(pos::Int) = IGate([pos])
XGate(pos::Int) = XGate([pos])
YGate(pos::Int) = YGate([pos])
ZGate(pos::Int) = ZGate([pos])
TGate(pos::Int) = TGate([pos])
#TODO: error here, two quibit gate should take two pos
TwoQubitGate(array::Vector{Number},pos) = QGate(ITensor(array,Index(2),Index(2), Index(2),Index(2)),pos)
SwapGate(pos::Vector{Int}) = TwoQubitGate([1.,0.,0.,0.,
								   0.,0.,1.,0.,
								   0.,1.,0.,0.,
								   0.,0.,0.,1.],pos)
CNOTGate(pos::Vector{Int}) = TwoQubitGate([1.,0.,0.,0.,
								   0.,1.,0.,0.,
								   0.,0.,0.,1.,
								   0.,0.,1.,0.],pos)

# Toffoli 



