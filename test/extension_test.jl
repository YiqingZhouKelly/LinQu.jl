include("./../src/YQ.jl")
using .YQ, Test

@testset "extension.jl test" begin
    @testset "ITensor getindex extension test" begin
    	A = rand(4,6)
    	i = Index(4)
    	j = Index(6)
    	T =ITensor(A, i,j)
    	ii = rand(1:4)
    	jj = rand(1:6)
    	@test T[(i, ii), (j, jj)] == A[ii,jj]
    	pair = [(i,ii), (j,jj)]
    	@test T[pair] == A[ii,jj]
	end
	@testset "ITensor contract extension test" begin
		i = Index(2)
		j = Index(5)
		k = Index(8)
		l = Index(2)
		A = rand(2,5)
		B = rand(8,2)
		TA = ITensor(A, i,j)
		TB = ITensor(B, k,l)
		TC = ITensor(B, k,i)
		@test contract(TA, TB, i,l) == TA*TC
	end
	@testset "clamp test" begin
	    A = rand(2,3)
	    i = Index(2)
	    j = Index(3)
	    T = ITensor(A, i,j)
	    @test clamp(T, i, 1) == ITensor(A[1,:], j)
	    @test clamp(T, j, 3) == ITensor(A[:,3], i)
	end
end