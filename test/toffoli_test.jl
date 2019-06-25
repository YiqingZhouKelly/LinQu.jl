# include("./../src/YQ.jl")
# using .YQ

state = MPSState(4)
circuit = QCircuit("toffoli_circuit.txt")
runCircuit!(state, circuit)
print(measure!(state, [1,2,3], 1024))