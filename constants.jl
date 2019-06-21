


toffoli = zeros(ones(Int, 6)*2 ...)
toffoli[1,1,1,1,1,1] = 1
toffoli[1,1,2,1,1,2] = 1
toffoli[1,2,1,1,2,1] = 1
toffoli[2,1,1,2,1,1] = 1
toffoli[2,2,1,2,2,2] = 1
toffoli[2,1,2,2,1,2] = 1
toffoli[1,2,2,1,2,2] = 1
toffoli[2,2,2,2,2,1] = 1
global const Toffoli = toffoli