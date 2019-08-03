
module YQ

include("./../../ITensors_release/src/ITensors.jl")

using .ITensors, LinearAlgebra, Random

import Base: length,
			 copy,
			 push!,
			 isless,
			 delete!,
			 getindex,
			 setindex,
			 findfirst,
			 deleteat!,
			 print,
			 show,
			 replace!,
			 reverse,
			 size,
			 +,
			 -,
			 *,
			 /,
			 ==,
			 isapprox,
			 pop!,
			 range,
			 clamp
import LinearAlgebra: norm,
					  normalize!
import .ITensors: linkindex,
				 getindex,
				 noprime,
				 noprime!,
				 prime,
				 svd,
				 qr,
				 position!,
				 setindex!,
				 commonindex,
				 leftLim,
				 rightLim,
				 iterate,
				 ITensor,
				 Index,
				 norm,
				 order,
				 *,
				 dag

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
	   IndexSet,
	   order
# Types
export  QState,
		QGate,
		QCircuit,
		MPSState,
		ExactState,
		QGateblock
		
include("extension.jl") 
export getindex, 
		contract, 
		clamp

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
export 	I,
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
		Rx,
		Ry,
		Rz,
		Rϕ,
		ROTATE

include("qstates/qstate.jl")
export 	QState,
		probability


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
	   collapse!,
	   showData,
	   normalize!,
	   dag,
	   ρ,
	   logprobability

include("qstates/exactstate.jl")
export 	ExactState,
		findindex,
		ITensor,
		toMPSState,
		isapprox

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
		randomQCircuit,
		showDetail

include("inter_qstate_qgate/exactstate_qgate.jl")
include("inter_qstate_qgate/mpsstate_qgate.jl")
include("inter_qstate_qgate/qstate_block_circuit.jl")
export  apply!

include("interface.jl")
export 	getindex,
		apply!

include("stat/sampling.jl")
export MCprobability!

# Following files are documentations
include("../doc/YQ_doc.jl")
end #module
