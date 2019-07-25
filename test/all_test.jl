include("./../src/YQ.jl")
using .YQ, LinearAlgebra, Test

include("extension_test.jl")
include("interface_test.jl")
include("qstates_test.jl")
include("toffoli_test.jl")
include("block_test.jl")