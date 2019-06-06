
module YQ
using ITensors
import Base.push!,
	   Base.length,
	   ITensors.push!,
	   Base.getindex,
	   Base.setindex!,
	   Base.copy,
	   ITensors.copy,
	   Base.deleteat!
## Types
export  QState,
		QGate,
		QCircuit,
		ITensorNet

include("tensornetwork.jl")
export  delete!,
		push!,
		contractall,
		contractsubset!
end

