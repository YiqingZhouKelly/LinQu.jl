
@doc """
    MPSState <: QState
""" ->
MPSState

@doc """
	MPSState(N::Int, init::Vector) 

Construct a MPSState with `N` qubits all initialized to given `init` vector.

# Arguments
- `N::Int`: the number of qubits
- `init::Vector{T} where T`: the unit vector representing the initial state of each qubit

# Examples
```jldoctest
julia> MPSState(2)
--- MPS state: ---
Site 1:IndexSet(Index[(1|id=164|Link,l=1), (2|id=46|Site,q=1)])
Site 2:IndexSet(Index[(1|id=164|Link,l=1), (2|id=866|Site,q=2)])
siteForQubit:[1, 2]
qubitAtSite:[1, 2]
llim = 0, rlim = 3
-------------------
```
""" ->
MPSState(N::Int, init::Vector)

@doc """
	MPSState(N::Int)
	
Construct |0> MPSState with `N` qubits.

Same as `MPSState(N, [1,0])`
""" ->
MPSState(N::Int)

@doc """
	getindex(state::MPSState, n::Int)

Return the ITensor at `n`th site in the MPSState.

Note: `n`th site is not the same as `n`th qubit.
""" ->
getindex(state::MPSState, n::Int)

@doc """
	getinds(state::MPSState, inds::Vector{Int})

Return ITensors at sites with indices provided in `inds` vector.

""" ->
getinds(state::MPSState, inds::Vector{Int})

@doc """
	setindex!(state::MPSState, T::ITensor, n::Integer)

Set the `n`th site of `state` to be ITensor `T`.

Note: No error checking. Should be careful when calling this function. 
""" ->
setindex!(state::MPSState, T::ITensor, n::Integer)

@doc """
	length(state::MPSState)

Return number of qubits.

""" ->
length(state::MPSState)

@doc """
	size(state::MPSState)
Return number of qubits.
""" ->
size(state::MPSState)

@doc """
	iterate(state::MPSState, itstate::Int=1)

Iterate through sites.
""" ->
iterate(state::MPSState, itstate::Int=1)

@doc """
	copy(state::MPSState)
Make a copy of `state`.
""" ->
copy(state::MPSState)

@doc """
	isapprox(state1::MPSState, state2::MPSState)
Inexact comparison between two MPSStates `state1` and `state2`.
""" ->
isapprox(state1::MPSState, state2::MPSState)

@doc """
	siteForQubit(state::MPSState, i::Int)
Return site index for qubit `i`.
""" ->
siteForQubit(state::MPSState, i::Int)

@doc """
	sitesForQubits(state::MPSState, inds::Vector{Int})

Return an array of site indices for given qubits.
""" ->
sitesForQubits(state::MPSState, inds::Vector{Int})

@doc """
	qubitAtSite(state::MPSState, i::Int)
Get which qubit is currently stored at site `n` in `state`.
""" ->
qubitAtSite(state::MPSState, i::Int)

@doc """
	qubitsAtSites(state::MPSState, inds::Vector{Int})
Get which qubits are currently stored at sites `inds` in `state`.
""" ->
qubitsAtSites(state::MPSState, inds::Vector{Int})

# @doc """
# 	updateMap!(state::MPSState, tuple)
	
# """ ->
# updateMap!(state::MPSState, tuple)

