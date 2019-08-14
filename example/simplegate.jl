using LinQu, Test, Random
import LinQu.data # data() is extended

struct IdentityGate <: QGate
	IdentityGate() = new()
end #struct

data(gate::IdentityGate) = [1 0; 0 1]