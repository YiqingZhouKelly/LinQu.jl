"""
	MCprobability!(state::QState; kwargs...)
Get probability distribution of qubit configurations by Monte Carlo sampling.

# Argument
- `state`: Any QState with **measure!** defined
- `samplesize`: Keyword argument to specify sample size. By default samplesize = 1024.
- `percentage`: Keyword argument. Return count of each configuration if set to `false`; return percentage frequency if set to `true`.
# Return Value
Returns a dinctionary data structure. The key of each pair is the qubit configuration; the value of the pair is frequency of appearance in sampling. 
#Example
julia> state = MPSState(2)
2-qubit MPSState


julia> apply!(state, H, ActPosition(1))
2-qubit MPSState


julia> d =MCprobability!(state; samplesize=1000)
Dict{Int64,Real} with 2 entries:
  0 => 509
  1 => 491


julia> d =MCprobability!(state; samplesize=1000, percentage = true)
Dict{Int64,Real} with 2 entries:
  0 => 0.47168
  1 => 0.504883

"""
function MCprobability!(state::QState; kwargs...)
	samplesize = get(kwargs, :samplesize, 1024)
	result = measure!(state, [1:length(state);], samplesize; binary = false)
	return frequency(result; kwargs...)
end

function frequency(v::Vector; kwargs...)
	percentage = get(kwargs, :percentage, false)
 	samplesize = get(kwargs, :samplesize, length(v))
 	cutoff = get(kwargs, :cutoff, 0)
 	abscutoff = get(kwargs, :abscutoff, 0)
 	if abscutoff !=0 && cutoff !=0
 		error("cannot specify both cutoff and abscutoff")
 	end
 	abscutoff ==0 && (abscutoff = cutoff*samplesize)
	dict = Dict{Int, Real}()
	for key ∈ v
		push!(dict, key => get!(dict, key, 0)+1)
	end
	for (k,s) ∈ dict
		if s <= abscutoff
			delete!(dict, k)
		elseif percentage
			push!(dict, k => s/samplesize)
		end
	end
	
	return dict
end