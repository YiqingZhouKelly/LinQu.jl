
@doc """
    MPSState <: QState

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
""" MPSState

@doc """
	MPSState(N::Int, init::Vector) 

Constructs a MPSState with `N` qubits all initialized to given `init` vector.

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
""" MPSState(N::Int, init::Vector)


