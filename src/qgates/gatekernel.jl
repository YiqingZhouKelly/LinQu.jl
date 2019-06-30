struct GateKernel
	f::Function
	name::String
	GateKernel(f::Function, name::String="") = new(f, name)
end

func(kernel::GateKernel) = kernel.f
name(kernel::GateKernel) = kernel.name