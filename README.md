A quantum circuit simulator using tensor network methods.

# Install
First, you should have Julia installed. If you haven't done that yet, follow this link to [Julia](https://julialang.org) official site.

To get started, run following commands:

```julia
import Pkg
# to install ITensors.jl
ITensors = Pkg.PackageSpec(url="https://github.com/ITensor/ITensors.jl.git")
# to install simulator
YQ =  Pkg.PackageSpec(url="https://github.com/YiqingZhouKelly/YQ.git")
Pkg.add([ITensors, YQ])
```
Then you should be ready to go!

# Tutorial
 (For more detailed examples, checkout the [`example`](https://github.com/YiqingZhouKelly/YQ/tree/master/example) folder.)
* Construct a state
```Julia
N = 5 # for 5 qubits
state1 = MPSState(N) # use MPS to represent state of a quantum device
state2 = ExactState(N) # use a tensor of order N to represent state of a quantum device
```
* Apply a gate  
  - Single qubit gate
```Julia
apply!(state, H, 1) # apply a Hadamard gate to qubit 1
apply!(state, H(1)) # alternative interface
```
 - Multiple qubit gate
 ```Julia
 # apply a CNOT gate to state, qubit 3 is control bit and qubit 5 is target bit
apply!(state, CNOT, [3,5])
apply!(state, CNOT(3,5))
 ```

* Build a QCircuit
```julia
N = 10 # 10 quits
state = MPSState(N)
circuit = QCircuit(N)
add!(circuit, H, 1)
add!(circuit, H(1),
              X(2),
              CNOT(1,2))
apply!(state, circuit)
```
