## YQ Quantum Circuit Simulator
* Language: [Julia](https://julialang.org)
* Dependency: [ITensors](https://itensor.org)
* Uses Tensor Network methods, namely _Matrix Product State (MPS)_ to simulate quantum circuit. The interface is adapted to the circuit model in quantum computation.

## TODO:
- [x] Get dependence working
- [x] Get basic gate application working
- [x] Design algm to support non-local gates (using SWAP gates)
- [x] Build YQ Module, clean up dependency
- [x] Renormalization after SVD truncation (Need to make sure gauge is properly positioned)
- [ ] Use pair data structure to store gate matrix, could make it easier to recognize SWAP gate
- [ ] Add support for left & right svd to reduce cost of moving gauge
- [x] Implement common gates
- [ ] Measurement (Need to read more literature to understand what is needed)
- [ ] QCircuit Basic Structure Design
- [ ] Add support for block of quantum circuits (maybe via QGateSet)
- [ ] Add user-friendly interface
- [ ] Sample quantum algorithms
- [x] Add support for Exact State
- [ ] Support Mixed state (part of the state was traced out)
- [ ] 

## Potential Changes/ Optimizations / Improvements
- [ ] Consider both adding SWAP and moving gauge when decide center of canonical form
- [ ] In QCircuit, currently localize(!) returns type QGateSet, meybe should change to QCircuit

## Need to think about:
- [x] Better way to recognize a SWAP gate (solved, see above)
- [ ] Maybe add support to remember truncation `kwargs...` (push in to interface.jl?)