mutable struct QGateBlock
	gates::QGateSet
	globalpos:: Int
	function QGateBlock(qgset::QGateSet)
		globalpos = range(qgset)[1]
		relpos_qgset = 
	end
end