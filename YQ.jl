
module YQ
include("/Users/yzhou/work/ITensors_fork/src/ITensors.jl")
using Main.ITensors
import Base.length,
	   Base.copy,
	   Base.push!,
	   Base.deleteat!,
	   Main.ITensors.linkind,
	   Main.ITensors.getindex,
	   Main.ITensors.noprime,
	   Main.ITensors.prime,
	   Main.ITensors.svd,
	   Main.ITensors.position!,
	   Main.ITensors.setindex!,
	   Main.ITensors.svd,
	   Main.ITensors.commonindex,
	   Main.ITensors.linkind
## Types
export  QState,
		QGate,
		QCircuit,
		ITensorNet

include("tensornetwork.jl")
export  delete!,
		push!,
		contractall,
		contractsubset!,
		deleteat!,
		getindex,
		setindex!,
		copy
include("qstate.jl")
include("qgate.jl")
include("qgateset.jl")
include("qcircuit.jl")
include("helper.jl")
end #module

