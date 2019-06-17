
module YQ

include("./../ITensors/src/ITensors.jl")

using .ITensors, LinearAlgebra
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
	   Base.replace!,
	   Base.reverse,
	   Base.*,
	   Base.pop!,
	   LinearAlgebra.norm,
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
	   .ITensors.leftLim,
	   .ITensors.rightLim,
	   .ITensors.iterate,
	   .ITensors.ITensor,
	   .ITensors.Index,
	   .ITensors.norm,
	   .ITensors.*

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
	   qr,
	   IndexSet
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
	   noprime!,
	   IndexSetdiff

include("qgate.jl")
export QGate,
	   gate_tensor,
	   copy,
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
	   TdagGate,
	   Rx,
	   Ry,
	   Rz,
	   SwapGate,
	   CNOTGate,
	   ITensor,
	   isswap,
	   sameposition,
	   repeatedswap,
	   ITensor,
	   reverse

include("qstates/qstate.jl")
export QState

include("qstates/mpsstate.jl")
export MPSState,
       length,
       getindex,
       setindex!,
       getlink,
       getfree,
       leftLim,
       rightLim,
       MPS_exact,
       position!,
       replace!,
       applylocalgate!,
       MPS_exact

include("qstates/exactstate.jl")
export 	ExactState,
		findindex,
		ITensor,
		applygate!
		# applylocalgate!

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

