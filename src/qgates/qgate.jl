
abstract type QGate end 

function QGate(kernel:: GateKernel)
	if paramCount(kernel)==0
		return ConstGate(kernel)
	else 
		return VarGate(kernel)
	end
end

#  visible to state
ITensor(gate::QGate, inds::IndexSet) = ITensor(data(gate), inds)
ITensor(gate::QGate, ind::Index...) = ITensor(data(gate), ind...)