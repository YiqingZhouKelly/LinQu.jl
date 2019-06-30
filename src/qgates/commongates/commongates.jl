
#ConstGate
X = ConstGate(X_kernel) 
Y = ConstGate(Y_kernel) 
Z = ConstGate(Z_kernel) 
H = ConstGate(H_kernel) 
S = ConstGate(S_kernel) 
SDAG = ConstGate(SDAG_kernel) 
T = ConstGate(T_kernel) 
TDAG = ConstGate(TDAG_kernel) 
SWAP = ConstGate(SWAP_kernel) 
CNOT = ConstGate(CNOT_kernel) 
TOFFOLI = ConstGate(TOFFOLI_kernel) 
FREDKIN = ConstGate(FREDKIN_kernel) 

# VarGates 
Rx(θ::Real) = VarGate(Rx_kernel, [θ])
Ry(θ::Real) = VarGate(Ry_kernel, [θ])
Rz(θ::Real) = VarGate(Rz_kernel, [θ])
Rϕ(θ::Real) = VarGate(Rϕ_kernel, [θ])