
module YQ

include("./../../ITensors/src/ITensors.jl")

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
	   Base.size,
	   Base.*,
	   Base.+,
	   Base.-,
	   Base.==,
	   Base.isapprox,
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
		QCircuit,
		MPSState,
		ExactState,
		QGateblock

include("actpos.jl")
export  ActPosition,
		randomActPosition

include("qgates/gatekernel.jl")
export  GateKernel,
		func,
		name
include("qgates/commongates/constants.jl")
export  IntFloat,
		Location,
		I_DATA,
		X_DATA,
		Y_DATA,
		Z_DATA,
		H_DATA,
		T_DATA,
		TDAG_DATA,
		S_DATA,
		SDAG_DATA,
		CNOT_DATA,
		SWAP_DATA,
		TOFFOLI_DATA,
		FREDKIN_DATA,
		CSWAP_DATA
include("qgates/commongates/commonkernel.jl")

include("qgates/qgate.jl")
export  QGate

include("qgates/constgate.jl")
export 	ConstGate,
		qubits,
		data,
		copy,
		control,
		randomConstGate

include("qgates/vargate.jl")
export  VarGate,
		qubits,
		param,
		func,
		copy,
		data,
		control,
		==,
		randomVarGate

include("qgates/measuregate.jl")
export MeasureGate,
	   qubits,
	   copy,
	   MEASURE_RESET,
	   MEASURE

include("qgates/commongates/commongates.jl")
export 	X,
		Y,
		Z,
		H,
		T,
		TDAG,
		S,
		SDAG,
		CNOT,
		SWAP,
		TOFFOLI,
		FREDKIN,
		CSWAP,
		Rx,
		Ry,
		Rz,
		Rϕ

include("qstates/mpsstate/qubitsitemap.jl")
export 	QubitSiteMap,
		updateMap!

include("qstates/mpsstate/mpsstate.jl")
export MPSState,
	   swapSites!,
	   applyLocalGate!,
	   localizeQubits!,
	   centerAtSite!,
	   centerAtQubit!,
	   moveQubit!,
	   moveSite!,
	   orderQubits!,
	   printFull,
	   applyGate!,
	   toExactState,
	   getProbDist,
	   oneShot,
	   measure!,
	   showData

include("qstates/exactstate.jl")
export 	ExactState,
		findindex,
		ITensor,
		toMPSState,
		isapprox

include("qstates/qstate.jl")
export 	QState

include("qgates/qgateblock.jl")
export  QGateBlock,
	    gates,
	    length,
	    push!,
	    add!,
	    addCopy!,
	    flatten, 
	    extractParams,
	    insertParams!,
	    inverse,
	    randomQGateBlock

include("qgates/qcircuit.jl")
export	add!,
		QCircuit,
		flatten,
		randomQCircuit

include("inter_qstate_qgate/exactstate_qgate.jl")
include("inter_qstate_qgate/mpsstate_qgate.jl")
include("inter_qstate_qgate/qstate_block_circuit.jl")
export  apply!

include("interface.jl")
export 	getindex
end #module

