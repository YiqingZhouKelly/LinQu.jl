
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

