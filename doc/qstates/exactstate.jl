
@doc """
	ExactState <: QState
# Structure
- `site::ITensor`: An order N tensor for a N-qubit system.
""" ->
ExactState

@doc """
	ExactState(N::Int, init::Vector{T}) where T<:Number
Construct a N-qubit Exact state with all qubit initialized to given initial value.
""" ->
ExactState(N::Int, init::Vector{T} where T<:Number)

@doc """
	ExactState(N::Int)
Construct an ExactState with N qubits all initialized to |0>.
""" ->
ExactState(N::Int)

@doc """
	copy(state::ExactState)
Make a copy of given state.
""" ->
copy(state::ExactState)

@doc """
	isapprox(state1::ExactState, state2::ExactState)
Do an approximate comparison between two states.
""" ->
isapprox(state1::ExactState, state2::ExactState)

@doc """
	numQubits(state::ExactState)
Return number of qubits in given state.
""" ->
numQubits(state::ExactState)

@doc """
	toMPSState(state::ExactState; kwargs...)
Turn given ExactState into a MPSState.
# Keyword Arguments
* The same as keywords taken by `svd`. See also **svd**.
""" ->
toMPSState(state::ExactState; kwargs...)

@doc """
	ρ(state::ExactState, config::Vector{Int})
Return probability density of given configuration.
""" ->
ρ(state::ExactState, config::Vector{Int})