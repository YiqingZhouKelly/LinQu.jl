mutable struct BlockMPSState <: QState
    sites::Vector{ITensor}
    dict::Dict{Int, Int}
    llim::Int
    rlim::Int

    BlockMPSState(sites::Vector{ITensor},
                  dict::Dict{Int, Int},
                  llim::Int,
                  rlim::Int) = new(sites, dict, llim, rlim)
end # struct

function BlockMPSState(N::Int, config::Dict{Int, Int})

end