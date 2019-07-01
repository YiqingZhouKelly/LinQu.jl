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
		controlled[2,:,2,:] = func(gate)(p...)
		return controlled
	end
	return GateKernel(controlFunc, paramCount(kernel), "Control-"*name(kernel))
end