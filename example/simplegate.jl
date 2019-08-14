using YQ, Test, Random
import YQ.data # data() is extended

struct IdentityGate <: QGate
	IdentityGate() = new()
end #struct

data(gate::IdentityGate) = [1 0; 0 1]