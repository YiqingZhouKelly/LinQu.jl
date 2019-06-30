
abstract type QGate end 

flatten(gate::QGate) = gate

#  visible to state
ITensor(gate::QGate, inds::IndexSet) = ITensor(data(gate), inds)
ITensor(gate::QGate, ind::Index...) = ITensor(data(gate), ind...)