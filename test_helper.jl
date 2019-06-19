
include("YQ.jl")
using .YQ,
	  Test
@testset "test exactMPS" begin
	@testset "whole state" begin
		for i = 1:3 
			inds = Index[]
			for i =1:5
				push!(inds, Index(rand(1:10),"Site, s=$(i)"))
			end
			A = randomITensor(inds...)
			its = exactMPS(A,[1,2,3,4,5])
			@test contractall(ITensorNet(its)) ≈ A
		end
	end
	@testset "left open test" begin
		for i =1:3 
			inds = Index[]
			push!(inds, Index(rand(1:10), "Link, l=1"))
			for i =2:6
					push!(inds, Index(rand(1:10),"Site, s=$(i)"))
			end
			A = randomITensor(inds...)
			its = exactMPS(A,[2,3,4,5,6])
			@test contractall(ITensorNet(its)) ≈ A
			@test A == A
		end
	end
	@testset "right open test" begin
	    for i = 1:3
	    	inds = Index[]
			push!(inds, Index(rand(1:10), "Link, l=5"))
			for i =1:5
					push!(inds, Index(rand(1:10),"Site, s=$(i)"))
			end
			A = randomITensor(inds...)
			its = exactMPS(A,[1,2,3,4,5])
			@test contractall(ITensorNet(its)) ≈ A
			@test A == A
	    end
	end
	@testset "both sides open test" begin
	    for i =1:3
	    	inds = Index[]
	    	push!(inds, Index(rand(1:10), "Link, l=1"))
			push!(inds, Index(rand(1:10), "Link, l=6"))
			for i =2:6
					push!(inds, Index(rand(1:10),"Site, s=$(i)"))
			end
			A = randomITensor(inds...)
			its = exactMPS(A,[2,3,4,5,6])
			@test contractall(ITensorNet(its)) ≈ A
			@test A == A
	    end

	end
end