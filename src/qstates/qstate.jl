
abstract type QState end

function probability(state::QState, config::Vector{Int})
	if numQubits(state) != length(config)
		error("Given configuration dimension does not match the state")
	end
	if any(config .> 1) || any(config .<0)
		error("Invalid configuration input.")
	end
	ρ_config = ρ(state, config)
	return Real(ρ_config*conj(ρ_config))
end