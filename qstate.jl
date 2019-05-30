abstract type QState end

struct MPSState <: QState
	s::MPS
end


# mutable struct MPSState
# 	state::MPS 

# 	MPSState()= new(MPS())
	
# 	function MPSState(N::Int)
# 		new(MPS(spinHalfSites(N)))
# 	end

# 	function MPSState(exact::ExactState)
# 	end
# end

# function 

struct MPSState 
	s::MPS
end 

