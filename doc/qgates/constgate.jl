
@doc """
	ConstGate <: QGate
# Structure
- `kernel::GateKernel` : See also **GateKernel**.
""" ->
ConstGate

@doc """
	ConstGate(data::Array{T} where {T<:Number}, name::String="Anonymous")
Construct a ConstGate.

# Arguments
- `data`: A tensor representation of the gate.
- `name`: Name string of the gate; used in print functions. Default value: "Anonymous".
# Example 
```Julia
julia> xdata = [0 1; 1 0]
2×2 Array{Int64,2}:
 0  1
 1  0

julia> Xgate = ConstGate(xdata, "self defined X")
self defined X
```
""" ->
ConstGate(data::Array{T} where {T<:Number}, name::String="Anonymous")

@doc """
	ConstGate(f::Function, name::String="Anonymous")
Construct a ConstGate with given function. 
# Arguments
- `f`: A function that returns gate tensor.
- `name`: Name string used in print functions. 
""" ->
ConstGate(f::Function, name::String="Anonymous")

# @doc """
# 	name(gate::ConstGate)
# Return name of the gate.

# """ ->
# name(gate::ConstGate)

# @doc """
# 	data(gate::ConstGate)
# Return gate tensor.
# """ ->
# data(gate::ConstGate)