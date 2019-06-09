## YQ Quantum Circuit Simulator
* Language: [Julia](https://julialang.org)
* Dependency: [ITensors](https://itensor.org)
* Uses Tensor Network methods, namely _Matrix Product State (MPS)_ to simulate quantum circuit. The interface is adapted to the circuit model in quantum computation.

## TODO:
- [x] Get dependence working
- [x] Get basic gate application working
- [ ] Design algm to support non-local gates (using SWAP gates)
- [ ] Measurement (Need to read more literature to understand what is needed)
- [ ] Build YQ Module, clean up dependency
- [ ] Add user-friendly interface
- [ ] Sample quantum algorithms

## Design Thoughts:
* For non-local gate, apply swap gate on both side to move them to the center (e.g. if apply on qubit 5 and 10, swap both 5 and 10 toward ~7)