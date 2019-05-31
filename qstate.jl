struct QState # maybe use subclass...?
	s::MPS
	statetype::String # MPSState, ExactState, MixedState
end



# abstract type QState end

# struct MPSState <: QState
# 	s::MPS
# end

# struct ExactState <: QState
# 	s::ITensor
# end

# struct MixedState <: QState
# 	s::
# end


# mutable struct MPSState
# 	state::MPS 

# 	MPSState()= new(MPS())
	
# 	function MPSState(N::Int)
# 		new(MPS(spinHalfSites(N)))
# 	end

# 	function MPSState(exact::ExactState)
# 	end
# end

