
I_func() = I_DATA
X_func() = X_DATA
Y_func() = Y_DATA
Z_func() = Z_DATA
H_func() = H_DATA
S_func() = S_DATA
SDAG_func() = SDAG_DATA
T_func() = T_DATA
TDAG_func() = TDAG_DATA
SWAP_func() = SWAP_DATA
CNOT_func() = CNOT_DATA
TOFFOLI_func() = TOFFOLI_DATA
FREDKIN_func() = FREDKIN_DATA

Rx_func(θ::Real) = cos(θ/2)I_DATA - sin(θ/2)im* X_DATA
Ry_func(θ::Real) = cos(θ/2)I_DATA - sin(θ/2)im* Y_DATA
Rz_func(θ::Real) = cos(θ/2)I_DATA - sin(θ/2)im* Z_DATA

function Rϕ_func(θ::Real)
	phaseGate = zeros(ComplexF64,2,2)
	phaseGate[1,1] = 1
	phaseGate[2,2] = exp(θ* 1im)
	return phaseGate
end

const I_kernel = GateKernel(I_func, "I")
const X_kernel = GateKernel(X_func, "X")
const Y_kernel = GateKernel(Y_func, "Y")
const Z_kernel = GateKernel(Z_func, "Z")
const H_kernel = GateKernel(H_func, "H")
const S_kernel = GateKernel(S_func, "S")
const SDAG_kernel = GateKernel(SDAG_func, "SDAG")
const T_kernel = GateKernel(T_func, "T")
const TDAG_kernel = GateKernel(TDAG_func, "TDAG")
const SWAP_kernel = GateKernel(SWAP_func, "SWAP")
const CNOT_kernel = GateKernel(CNOT_func, "CNOT")
const TOFFOLI_kernel = GateKernel(TOFFOLI_func, "TOFFOLI")
const FREDKIN_kernel = GateKernel(FREDKIN_func, "FREDKIN")
const Rx = GateKernel(Rx_func, 1, "Rx")
const Ry = GateKernel(Ry_func, 1, "Ry")
const Rz = GateKernel(Rz_func, 1, "Rz")
const Rϕ = GateKernel(Rϕ_func, 1, "Rϕ")