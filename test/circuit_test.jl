include("./../src/YQ.jl")
using .YQ

block = QGateBlock()
push!(block, H(3))
push!(block, X(2))
print(block, "\n")

circuit = QCircuit()
push!(circuit, Y(5))
push!(circuit, block)

newBlock = QGateBlock(circuit)
print(newBlock,"\n")
print(zeroOffset(newBlock),"\n")
print(newBlock,"\n")