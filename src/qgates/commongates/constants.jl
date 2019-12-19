const IntFloat = Union{Int, Float64}
const Location = Union{Vector{Int}, Int}
# 1-qubit gates
i = zeros(ComplexF64,2,2)
i[1,1] = 1
i[2,2] = 1
const I_DATA = i

x = zeros(ComplexF64,2,2)
x[2,1] = 1
x[1,2] = 1
const X_DATA = x

y = zeros(ComplexF64,2,2)
y[1,2] = -1im
y[2,1] = 1im
const Y_DATA = y

z = zeros(ComplexF64,2,2)
z[1,1] = 1
z[2,2] = -1
const Z_DATA = z

h = ones(ComplexF64,2,2)
h[2,2] = -1
const H_DATA = h/√2

s = zeros(ComplexF64,2,2)
s[1,1] = 1 
s[2,2] = 1im
const S_DATA = s

sdag = zeros(ComplexF64,2,2)
sdag[1,1] = 1 
sdag[2,2] = -1im
const SDAG_DATA = sdag

t = zeros(ComplexF64,2,2)
t[1,1] = 1
t[2,2] = exp(π/4im)
const T_DATA = t

tdag = zeros(ComplexF64,2,2)
tdag[1,1] = 1
tdag[2,2] = exp(-π/4im)
const TDAG_DATA = tdag


#2-qubit gates
swap = zeros(ComplexF64,2,2,2,2)
swap[1,1,1,1] = 1
swap[2,2,2,2] = 1
swap[1,2,2,1] = 1
swap[2,1,1,2] = 1
const SWAP_DATA =swap

cnot = zeros(ComplexF64, 2,2,2,2)
cnot[1,1,1,1] = 1
cnot[1,2,1,2] = 1
cnot[2,1,2,2] = 1
cnot[2,2,2,1] = 1
const CNOT_DATA = cnot

# 3-qubit gates
toffoli = zeros(ComplexF64,2,2,2,2,2,2)
toffoli[1,1,1,1,1,1] = 1
toffoli[1,1,2,1,1,2] = 1
toffoli[1,2,1,1,2,1] = 1
toffoli[2,1,1,2,1,1] = 1
toffoli[2,2,1,2,2,2] = 1
toffoli[2,1,2,2,1,2] = 1
toffoli[1,2,2,1,2,2] = 1
toffoli[2,2,2,2,2,1] = 1
const TOFFOLI_DATA = toffoli

fredkin = zeros(ComplexF64,2,2,2,2,2,2)
for i =1:2
	for j= 1:2
		fredkin[1,i,j,1,i,j] = 1
		fredkin[2,i,j,2,j,i] = 1
	end
end
const FREDKIN_DATA = fredkin
const CSWAP_DATA = fredkin

cz = zeros(ComplexF64, 2,2,2,2)
cz[1,1,1,1] = 1
cz[1,2,1,2] = 1
cz[2,1,2,1] = 1
cz[2,2,2,2] = -1
const CZ_DATA = cz
