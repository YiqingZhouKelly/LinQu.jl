
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
	   Base.range,
	   LinearAlgebra.norm,
	   .ITensors.linkindex,
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
export linkindex,
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
		contractAll,
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
	   IndexSetdiff,
	   exactMPS

# include("qgate.jl")
# export QGate,
# 	   gate_tensor,
# 	   qubits, #new
# 	   data, #new
# 	   copy,
# 	   nonlocal_local,
# 	   mult_nonlocal_local,
# 	   movegate!,
# 	   movegate,
# 	   IGate,
# 	   XGate,
# 	   YGate,
# 	   ZGate,
# 	   TGate,
# 	   HGate,
# 	   SGate,
# 	   TdagGate,
# 	   Rx,
# 	   Ry,
# 	   Rz,
# 	   SwapGate,
# 	   CNOTGate,
# 	   ToffoliGate,
# 	   ITensor,
# 	   isswap,
# 	   sameposition,
# 	   repeatedswap,
# 	   ITensor,
# 	   reverse

include("qgate_new.jl")
export  qubits,
		data,
		IGate,
		XGate,
		YGate,
		ZGate,
		TGate,
		HGate,
		SGate,
		TdagGate,
		RxGate,
		RyGate,
		RzGate,
		SwapGate,
		CNOTGate,
		ToffoliGate,
		ITensor


include("qstates/qstate.jl")
export QState

include("qstates/mpsstate.jl")
export MPSState,
	   swapSites!,
	   applyLocalGate!,
	   localizeQubits!,
	   centerAtSite!,
	   moveQubit!,
	   orderQubits!,
	   printFull,
	   applyGate!,
	   toExactState
#        length,
#        getindex,
#        setindex!,
#        getlink,
#        getfree,
#        leftLim,
#        rightLim,
#        MPS_exact,
#        position!,
#        replace!,
#        applylocalgate!,
#        MPS_exact

include("qstates/exactstate.jl")
export 	ExactState,
		findindex,
		ITensor,
		applyGate!,
		toMPSState
		# applylocalgate!

include("qgateset.jl")
export QGateSet,
	   applylocalgate!,
	   QGate,
	   length,
	   setindex!,
	   getindex,
	   range

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

