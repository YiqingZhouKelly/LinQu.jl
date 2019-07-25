
import Base.getindex,
	   .YQ.ITensors.getindex,
	   .YQ.ITensors.IndexVal

function Rotate(θ,nx,ny,nz)
	len = norm([nx,ny,nz])
	nx/=len
	ny/=len
	nz/=len
	return cos(θ/2)*I_DATA-1im*sin(θ/2)*(nx*X_DATA+ ny*Y_DATA+nz*Z_DATA)
end

U1 = VarGate(Rotate, [-0.75, 1,1,2])
U2 = VarGate(Rotate, [2.14, 1,2,1])

function test_circuit(N::Int)
	circuit= QCircuit(N)
	add!(circuit, U2(4))
	for i=1:4
		add!(circuit, U1(i))
	end
	add!(circuit, CNOT(1,2), CNOT(3,4))
	for i =1:4
		add!(circuit, U1(i))
	end
	add!(circuit, control(Z)(2,3))
	return circuit
end

function getindex(T::ITensor, inds::IndexSet, i::Vector{Int})
	if length(inds) != length(i)
		error("dimension of inds and i mismatch!")
	end
	ivs = Array{IndexVal,1}(undef, 0)
	for j = 1:length(i)
		push!(ivs, IndexVal(inds[j], i[j]))
	end
	return getindex(T, ivs...)
end

function print_prob(state::ExactState)
	N = order(state.site)
	inds = IndexSet()
	for i = 1:4
		push!(inds, findindex(state.site, "q=$(i)"))
	end
	for ii =0:2^N-1
	    index = [Int((ii&a)/a) for a∈ [1,2,4,8]]
	    amp = state.site[inds, (index.+1)]
	    print(index,"	>	", Real(amp*conj(amp)), "		", amp , "\n")
	end
end

function main()
	N=4
	mps_state = MPSState(N)
	exact_state = toExactState(mps_state)
	circuit = test_circuit(N)
	apply!(exact_state, circuit)
	apply!(mps_state, circuit)
	normalize!(mps_state)
	@test exact_state ≈ toExactState(mps_state)
	print_prob(exact_state)
end

main()
