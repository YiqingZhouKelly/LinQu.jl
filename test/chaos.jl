include("./../YQ.jl")
using YQ.jl

block = QGateBlock()
push!(block, Rx(π,5))
push!(block, Rx(π,3))