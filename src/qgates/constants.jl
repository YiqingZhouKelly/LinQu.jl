const IntFloat = Union{Int, Float64}
const Location = Union{Vector{Int}, Int}
# 1-qubit gates
i = zeros(Complex,2,2)
i[1,1] = 1
i[2,2] = 1
const I_DATA = i

x = zeros(Complex,2,2)
x[2,1] = 1
x[1,2] = 1
const X_DATA = x

y = zeros(Complex,2,2)
y[1,2] = -1im
y[2,1] = 1im
const Y_DATA = y

z = zeros(Complex,2,2)
z[1,1] = 1
z[2,2] = -1
const Z_DATA = z

h = ones(Complex,2,2)
h[2,2] = -1
const H_DATA = h/√2

s = zeros(Complex,2,2)
s[1,1] = 1 
s[2,2] = 1im
const S_DATA = s
const SDAG_DATA = s'

t = zeros(Complex,2,2)
t[1,1] = 1
t[2,2] = exp(π/4im)
const T_DATA = t
const TDAG_DATA = t'


#2-qubit gates
swap = zeros(Complex,2,2,2,2)
swap[1,1,1,1] = 1
swap[2,2,2,2] = 1
swap[1,2,2,1] = 1
swap[2,1,1,2] = 1
const SWAP_DATA =swap

cnot = zeros(Complex, 2,2,2,2)
cnot[1,1,1,1] = 1
cnot[1,2,1,2] = 1
cnot[2,1,2,2] = 1
cnot[2,2,2,1] = 1
const CNOT_DATA = cnot

# 3-qubit gates
toffoli = zeros(Complex,2,2,2,2,2,2)
toffoli[1,1,1,1,1,1] = 1
toffoli[1,1,2,1,1,2] = 1
toffoli[1,2,1,1,2,1] = 1
toffoli[2,1,1,2,1,1] = 1
toffoli[2,2,1,2,2,2] = 1
toffoli[2,1,2,2,1,2] = 1
toffoli[1,2,2,1,2,2] = 1
toffoli[2,2,2,2,2,1] = 1
const TOFFOLI_DATA = toffoli

fredkin = zeros(Complex,2,2,2,2,2,2)
for i =1:2
	for j= 1:2
		fredkin[1,i,j,1,i,j] = 1
		fredkin[2,i,j,2,j,i] = 1
	end
end
const FREDKIN_DATA = fredkin
const CSWAP_DATA = fredkin

const GATE_TABLE = [X_DATA, Y_DATA, Z_DATA, H_DATA, S_DATA, SDAG_DATA, T_DATA, TDAG_DATA, SWAP_DATA, CNOT_DATA, TOFFOLI_DATA, FREDKIN_DATA, I_DATA]