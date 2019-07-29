@doc """
	apply!(state::ExactState, gate::QGate, qubits::Vector{Int}; kwarg...)
Apply `gate` to `state` on given `qubits`.
# Keyword Arguments
* All following keyword arguments are passed to svd operation 1)to control the truncation accuracy 2) to specify the source of svd to call (BLAS or ITensors build-in)
- `maxdim::Int`: Maximal bond dimension for links between sites. 
- `mindim::Int`: Minimal bond dimension for links between sites. 
- `cutoff::Float64`: Truncation criterion. 
- `absoluteCutoff::Bool`: Truncate singular values smaller than `cutoff`.
- `doRelCutoff::Bool`: Truncate the bottom `cutoff` fraction of singular values by norm. 
- `fastSVD::Bool`: Calling BLAS svd if set to `false`; calling ITensors' recursive svd subroutine if set to `true`.
""" ->
apply!(state::ExactState, gate::QGate, qubits::Vector{Int}; kwarg...)