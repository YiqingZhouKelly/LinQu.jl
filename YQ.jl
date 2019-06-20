
module YQ

include("./../../work/ITensors/src/ITensors.jl")

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
		contractSubset!,
		deleteat!,
		getindex,
		setindex!,
		copy


include("qgate.jl")
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

include("qstates/exactstate.jl")
export 	ExactState,
		findindex,
		ITensor,
		applyGate!,
		toMPSState

end #module

