include("./../src/YQ.jl")
using .YQ

state = MPSState(4)
circuit = QCircuit("test/GHZ_circuit.txt")
runCircuit!(state, circuit)
print(measure!(state, [1,2,3,4], 1024))
