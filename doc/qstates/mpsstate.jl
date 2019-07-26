
@doc """
    MPSState <: QState
# Structure
- `sites::Vector{ITensor}`: Array of ITensors storing MPS sites.
- `map::QubitSiteMap`: A binary map between qubit and site(position).
- `llim::Int`: Sites to the left of llim is guaranteed to be orthogonal. 
- `rlim::Int`: Sites to the right of rlim is guaranteed to be orthogonal.
""" ->
MPSState

@doc """
	MPSState(N::Int, init::Vector) 

Construct a MPSState with `N` qubits all initialized to given `init` vector.

# Arguments
- `N::Int`: the number of qubits
- `init::Vector{T} where T`: the unit vector representing the initial state of each qubit

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

Return ITensors at sites with indices provided by `inds` vector.

""" ->
getinds(state::MPSState, inds::Vector{Int})


@doc """
	setindex!(state::MPSState, T::ITensor, n::Integer)

Set the `n`th site of `state` to be ITensor `T`.

#Note: 
No error checking. Should be careful when calling this function. 
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


@doc """
	updateMap!(state::MPSState; kwargs...)
Update state.map according to qubit-site pair proveided in keyword arguments.

# Arguments
- `state`: MPSState
- `q`: [_keyword argument_] Qubit index. Default value: -1. 
- `s`: [_keyword argument_] Site index. Default value: -1.

# Note: 
This function is intended for internal use. 
""" ->
updateMap!(state::MPSState; kwargs...)


@doc """
	function updateLims!(state::MPSState, leftEnd::Int, rightEnd::Int)
Update `state.llim` and `state.rlim`.

# Arguments
- `state` : MPSState
- `leftEnd`: _Site_ index of the most left modified site.
- `rightEnd`: _Site_ index of the most right modified site.

# Note: 
This function is intended for internal use.
""" ->
updateLims!(state::MPSState, leftEnd::Int, rightEnd::Int)


@doc """
	updateLims!(state::MPSState, touchedSite::Int)
Update `state.llim` and `state.rlim` according to modified site.

# Note: 
This function is intended for internal use.
""" ->
updateLims!(state::MPSState, touchedSite::Int)


@doc """
	getQubit(state::MPSState, i::Int)
Return ITensor for qubit with index `i`.
""" ->
getQubit(state::MPSState, i::Int)


@doc """
	getQubits(state::MPSState, inds::Vector{Int})
Return ITensors for qubits specified in `inds`.
""" ->
getQubits(state::MPSState, inds::Vector{Int})


@doc """
	siteIndex(state::MPSState, i::Int)
Return site index in the ITensor at site `i`.
# Arguments:
- `state`: MPSState
- `i`: Site index

# Return Value:
Index object.

# Note: 
This function is intended for internal use.
""" ->
siteIndex(state::MPSState, i::Int)


@doc """
	siteInds(state::MPSState, inds::Vector{Int})
Return site indices in the ITensor at sites `inds`.

# Arguments:
- `state`: MPSState
- `inds`: Site indices

# Return Value:
IndexSet object.

# Note: 
This function is intended for internal use.
""" ->
siteInds(state::MPSState, inds::Vector{Int})


@doc """
	toExactState(state::MPSState)
Turn a MPSState to an ExactState.

# Note: 
This is a costly operation and is intended for MPSState testing.
""" ->
toExactState(state::MPSState)


@doc """
	normalize!(state::MPSState; kwargs...)
Normalize the MPSState by getting it into canonical form and normalize at the center.

# Arguments
- `state`: MPSState
- `center`: [_keyword argument_] Site index for gauge center. Default value: state.llim+1.
""" ->
normalize!(state::MPSState; kwargs...)


@doc """
	measure!(state::MPSState, qubits::Vector{Int}, shots::Int; kwargs...)
Perform measurement to specified `qubits` in computatioal basis for `shots` times.

# Arguments
- `state`: MPSState
- `qubits`: vector of qubits to be measured
- `shots`: number of measurements to be performed
- `binary`: [_keyword argument_] If `binary == true`, the function returns results in binary form in a 2D array. Otherwise, the function returns measurement results in decimal form. Default value: `false`.  
- `probability`: [_keyword argument_] whether or not to keep probability as a by-product.

# Example
``` julia
julia> state = MPSState(3) # generate 3-qubit |0> state
3-qubit MPSState

julia> apply!(state, H, ActPosition(1)) # apply Hadamard gate at qubit 1
3-qubit MPSState

julia> result = measure!(state, [1:3;], 5)
5×3 Array{Int64,2}:
 0  0  0
 1  0  0
 0  0  0
 1  0  0
 0  0  0

julia> result[4,1] # outcome of 1st qubit at 4th measurement
1

julia> measure!(state, [1:3;], 5; binary = false)
5-element Array{Int64,1}:
 0
 0
 1
 1
 1

julia> measure!(state, [1:3;], 3; binary = true, probability = true)
([0 0 0; 0 0 0; 1 0 0], [0.5, 0.5, 0.5])
``` 
 # Note
Calling this function will not physically change state, but the internal data structure (e.g. the position of gauge center) of the MPS may be changed.  
See also: **collapse!**
""" ->
measure!(state::MPSState, qubits::Vector{Int}, shots::Int; kwargs...)


@doc """
	measure!(state::MPSState, qubit::Int, shots::Int; kwargs...)
Perform measuremt to specified qubit in computational basis.

# Arguments
- `state`: MPSState
- `qubit`: qubit to be measured
- `shots`: number of measurements to be performed
- `binary`: [_keyword argument_] If `binary == true`, the function returns results in binary form in a 2D array. Otherwise, the function returns measurement results in decimal form. Default value: `false`.  
""" ->
measure!(state::MPSState, qubit::Int, shots::Int; kwargs...)


@doc """
	orderQubits!(state::MPSState; kwargs...)
Reorder internal storage of MPSState; make site index match qubit index.
""" ->
orderQubits!(state::MPSState; kwargs...)

@doc """
	moveQubit!(state::MPSState, q::Int, s::Int; kwargs...)
Move qubit `q` to site `s`. `kwargs` are used for svd truncation (See **svd**.)
""" ->
moveQubit!(state::MPSState, q::Int, s::Int; kwargs...)

@doc """
	localizeQubitsInOrder!(state::MPSState, qubits::Vector{Int}; kwargs...)
Localize `qubits` respecting the given ordering. 

The specified qubits are moved to the front of MPS by calling **moveQubit!**.
""" ->
localizeQubitsInOrder!(state::MPSState, qubits::Vector{Int}; kwargs...)


@doc """
	centerAtSite!(state::MPSState, s::Int)
Canonicalize MPS and put the canonical center at site `s`.

# Note:
MPS will be auto-normalized after canonicalization.
""" ->
centerAtSite!(state::MPSState, s::Int)

@doc """
	centerAtQubit!(state::MPSState, q::Int)
Canonicalize MPS and put the canonical center at qubit `q`.
""" ->
centerAtQubit!(state::MPSState, q::Int)

@doc """
	swapSites!(state::MPSState, s1::Int, s2::Int, decomp= "svd"; kwargs...)
Swapping two _neighboring_ sites. 
""" ->
swapSites!(state::MPSState, s1::Int, s2::Int, decomp= "svd"; kwargs...)


@doc """
	oneShot(state::MPSState, sites::Vector{Int}; kwargs...)
Doing one measurement on state.

This is a helper function called by **measure!**. The state needs to be pretreated (localize qubits to be measured & canonicalize) before calling this funciton. 

# Note: Internal function.
""" ->
oneShot(state::MPSState, sites::Vector{Int}; kwargs...)

@doc """
	collapse!(state::MPSState, qubit::Int; kwargs...)
Collapse the specified qubit and return the measurement result. 

# Argument 
- `state` : MPSState
- `qubit`: qubit to be collapsed
- `reset`: [_keyword argument_] Whether or not to reset measured qubit to |0>. Default value: false. 

# Example
``` julia
julia> state = MPSState(1)
1-qubit MPSState


julia> apply!(state, H, ActPosition(1))
1-qubit MPSState


julia> measure!(state, 1, 4)
4-element Array{Int64,1}:
 0
 0
 1
 1

julia> collapse!(state, 1)
0

julia> measure!(state, 1, 4)
4-element Array{Int64,1}:
 0
 0
 0
 0

```
""" ->
collapse!(state::MPSState, qubit::Int; kwargs...)


@doc """
	collapse!(state::MPSState, qubits::Vector{Int}; kwargs...)
Collapse the specified qubits and return the measurement result.
""" ->
collapse!(state::MPSState, qubits::Vector{Int}; kwargs...)


@doc """
	dag(state::MPSState)
Return complex conjugate of the MPSState.
""" ->
dag(state::MPSState)


@doc """
	showStructure(io::IO, state::MPSState)
Print structure of the MPSState.

# Example 
```
julia> state = MPSState(3)
3-qubit MPSState


julia> showStructure(stdout, state)
MPSState
Site 1:IndexSet(Index[(1|id=414|Link,l=1), (2|id=485|Site,q=1)])
Site 2:IndexSet(Index[(1|id=414|Link,l=1), (1|id=969|Link,l=2), (2|id=707|Site,q=2)])
Site 3:IndexSet(Index[(1|id=969|Link,l=2), (2|id=363|Site,q=3)])
siteForQubit:[1, 2, 3]
qubitAtSite:[1, 2, 3]
llim = 0, rlim = 4
```
See also: **showData**
""" -> 
showStructure(io::IO, state::MPSState)

@doc """
	showData(io::IO,state::MPSState)
Print both structure and stored tensor data.

#Example

```
julia> state = MPSState(3)
3-qubit MPSState


julia> showData(stdout, state)
--- MPS state: ---
Site 1:
ITensor ord=2 (1|id=570|Link,l=1) (2|id=57|Site,q=1)
Main.YQ.ITensors.Dense{Float64}
 1.0  0.0
Site 2:
ITensor ord=3 (1|id=570|Link,l=1) (1|id=598|Link,l=2) (2|id=555|Site,q=2)
Main.YQ.ITensors.Dense{Float64}
[:, :, 1] =
 1.0

[:, :, 2] =
 0.0
Site 3:
ITensor ord=2 (1|id=598|Link,l=2) (2|id=278|Site,q=3)
Main.YQ.ITensors.Dense{Float64}
 1.0  0.0
```

See also: **showStructure**
""" ->
showData(io::IO,state::MPSState)

@doc """
	ρ(state::MPSState, config::Vector{Int})
Return probability density of the given configuration. 

# Example
```julia
julia> state = MPSState(5)
5-qubit MPSState


julia> apply!(state, H(1))
5-qubit MPSState


julia> ρ(state, [0,0,0,0,0])
0.7071067811865475 + 0.0im

julia> ρ(state, [1,0,0,0,0])
0.7071067811865475 + 0.0im
```
# Note: 
Length of `config` must match number of qubits in the state. 
""" ->
ρ(state::MPSState, config::Vector{Int})

