
module YQ

include("./../ITensors_fork/src/ITensors.jl")

using .ITensors
import Base.length,
	   Base.copy,
	   Base.push!,
	   Base.isless,
	   Base.delete!,
	   Base.getindex,
	   Base.setindex!,
	   Base.findfirst,
	   Base.deleteat!,
	   Base.print,
	   Base.show,
	   .ITensors.linkind,
	   .ITensors.getindex,
	   .ITensors.noprime,
	   .ITensors.noprime!,
	   .ITensors.prime,
	   .ITensors.svd,
	   .ITensors.qr,
	   .ITensors.position!,
	   .ITensors.setindex!,
	   .ITensors.svd,
	   .ITensors.commonindex,
	   .ITensors.linkind,
	   .ITensors.leftLim,
	   .ITensors.rightLim,
	   .ITensors.iterate,
	   .ITensors.ITensor,
	   .ITensors.Index

# functions from Base, ITensors
export linkind,
	   getindex,
	   noprime,
	   noprime!,
	   prime,
	   svd,
	   position!,
	   setindex!,
	   svd,
	   commonindex,
	   linkind,
	   leftLim,
	   rightLim,
	   iterate,
	   ITensor,
	   Index,
	   randomITensor,
	   qr
# Types
export  QState,
		QGate,
		QGateSet,
		QCircuit,
		ITensorNet,
		MPSState

include("tensornet.jl")
export  TensorNet,
		delete!,
		push!,
		contractall,
		contractsubset!,
		deleteat!,
		getindex,
		setindex!,
		copy

include("helper.jl")
export exact_MPS,
	   stepsize,
	   optpos,
	   noprime!

include("qgate.jl")
export QGate,
	   gate_tensor,
	   copy,
	   checklocal,
	   nonlocal_local,
	   movegate!,
	   movegate,
	   IGate,
	   XGate,
	   YGate,
	   ZGate,
	   TGate,
	   HGate,
	   SGate,
	   Rx,
	   Ry,
	   Rz,
	   SwapGate,
	   CNOTGate,
	   ITensor,
	   isswap,
	   sameposition,
	   repeatedswap

include("qstate.jl")
export QState,
       MPSState,
       length,
       getindex,
       setindex!,
       getlink,
       getfree,
       leftLim,
       rightLim,
       MPS_exact,
       position!,
       movegauge!,
       replace!,
       applylocalgate!,
       applysinglegate!



include("qgateset.jl")
export QGateSet,
	   applylocalgate!,
	   QGate,
	   length,
	   setindex!,
	   getindex

include("qcircuit.jl")
export QCircuit,
	   gates,
	   state,
	   push!,
	   localize,
	   localize!,
	   minswap,
	   minswap!,
	   minswap_localize!,
	   print,
	   show,
	   runlocal!,
	   cleargates!
end #module

