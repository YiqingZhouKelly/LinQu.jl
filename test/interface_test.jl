
@testset "interface test" begin
    @testset "control gate" begin
        @test control(X) == ConstGate(control(LinQu.X_kernel))
        @test control(Rx)[π] == control(Rx[π])
    end
end