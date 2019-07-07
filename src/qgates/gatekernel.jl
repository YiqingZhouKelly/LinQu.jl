struct GateKernel
	f::Function
	paramCount::Int
	name::String
	GateKernel(f::Function, name::String="Anonymous") = new(f, 0, name)
	GateKernel(f::Function, paramCount::Int,name::String="Anonymous") = new(f, paramCount, name)
end

func(kernel::GateKernel) = kernel.f
paramCount(kernel::GateKernel) = kernel.paramCount
name(kernel::GateKernel) = kernel.name

function control(kernel::GateKernel)
	function controlFunc(p::Real...)
		controlled = zeros(ComplexF64,2,2,2,2)
		controlled[1,:,1,:] = diagm(0=>ones(ComplexF64, 2))
		controlled[2,:,2,:] = func(kernel)(p...)
		return controlled
	end
	return GateKernel(controlFunc, paramCount(kernel), "Control-"*name(kernel))
end

function inverse(kernel::GateKernel)
	# TODO: need optimization
	function inverse(p::Real...)
		tensor = conj(kernel.f(p...))
		shape = size(tensor)
		n = Int(√length(tensor))
		tensor = transpose(reshape(tensor, n,n))
		return Array(reshape(tensor, shape...))
	end
	return GateKernel(inverse, paramCount(kernel), name(kernel)*"†")
end