
struct ActPosition
	qubits::Vector{Int}
	ActPosition(qubit::Int...) = new([qubit...])
	ActPosition(qubits::Vector{Int}) = new(qubits)
end #struct

qubits(pos::ActPosition) = pos.qubits
copy(pos::ActPosition) = ActPosition(copy(pos.qubits))

getindex(pos::ActPosition, i::Int) = getindex(pos.qubits, i)
setindex!(pos::ActPosition, q::Int, i::Int) = setindex!(pos.qubits, q, i)

length(pos::ActPosition) = length(pos.qubits)
size(pos::ActPosition) = size(qubits(pos))
iterate(pos::ActPosition, state::Int=1) = iterate(pos.qubits,state)
==(pos1::ActPosition, pos2::ActPosition) = (pos1.qubits == pos2.qubits)