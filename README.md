A quantum circuit simulator using tensor network methods.

# Install
To get started, run following commands:

```julia
import Pkg
# to install ITensors.jl
ITensorsPkg = Pkg.PackageSpec(url="https://github.com/ITensor/ITensors.jl.git")
# to install LinQu
LinQuPkg =  Pkg.PackageSpec(url="https://github.com/YiqingZhouKelly/LinQu.jl.git")
Pkg.add([ITensorsPkg, LinQuPkg])
```
Then you should be ready to go!

# Tutorial
 (For more detailed examples, checkout the [`example`](https://github.com/YiqingZhouKelly/LinQu.jl/tree/master/example) folder.)
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
* Allow SVD truncation for approximation
```julia
N = 10 # 10 quits
state = MPSState(N)
circuit = QCircuit(N)
add!(circuit, H, 1)
add!(circuit, H(1),
              X(2),
              CNOT(1,2))

apply!(state, circuit; maxdim = 10) # use keyword arguments
                                    # to specify truncation 
                                    # mode
# see doc string of apply! function for a complete set of supported keyword arguments
```
* Measurements
  - `measure!`: This function does not change the current state physically, but may change the gauge center. 
  - `collapse!`: This function collapses measured qubits to measurement results (i.e. changes the physical meaning current state).
```julia
julia> state = MPSState(10)
10-qubit MPSState


julia> apply!(state, H, 1)
10-qubit MPSState

julia> measure!(state, 1, 3)
3-element Array{Int64,1}:
 0
 1
 0

 julia> measure!(state, 1, 3) 
3-element Array{Int64,1}:
 1
 0
 0

 julia> collapse!(state, 1)
0

julia> sum(measure!(state, 1, 100)) #always get zero after calling collapse!
0
```
