
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
	   Base.*,
	   Base.+,
	   Base.-,
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

include("qgates/constants.jl")
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
		CSWAP_DATA,
		GATE_TABLE,
		GATE_NAME,
		CONST_GATE_COUNT

include("qgates/constgate.jl")
export 	ConstGate,
		X,
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
		qubits,
		data,
		id,
		copy,
		ITensor

include("qgates/vargate.jl")
export  VarGate,
		qubits,
		data,
		id,
		θ,
		Rx,
		Ry,
		Rz,
		Rϕ,
		copy,
		ITensor

include("qgates/customizedgate.jl")
export  CustomizedGate,
		qubits,
		param,
		func,
		copy,
		data,
		changeParam!,
		changeParam

include("qgates/qgate.jl")
export  QGate

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
	   measure!

include("qstates/exactstate.jl")
export 	ExactState,
		findindex,
		ITensor,
		applyGate!,
		toMPSState

include("qstates/qstate.jl")
export 	QState

include("qgateblock.jl")
export  QGateBlock,
	    gates,
	    length,
	    push!,
	    applyGate!,
	    zeroOffset

include("qcircuit.jl")
export	Operator,
		QCircuit,
		operators,
		QGateBlock,
		runCircuit!
end #module

