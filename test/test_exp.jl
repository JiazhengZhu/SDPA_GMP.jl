
@testset "Exp Atoms: $solver" for solver in solvers
    if can_solve_exp(solver)
        @testset "exp atom" begin
            y = Variable()
            p = Problem{BigFloat}(:minimize, exp(y), y>=0)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ 1 atol=TOL
            @test evaluate(exp(y)) ≈ 1 atol=TOL

            y = Variable()
            p = Problem{BigFloat}(:minimize, exp(y), y>=1)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ exp(1) atol=TOL
            @test evaluate(exp(y)) ≈ exp(1) atol=TOL

            y = Variable(5)
            p = Problem{BigFloat}(:minimize, sum(exp(y)), y>=0)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ 5 atol=TOL
            @test evaluate(sum(exp(y))) ≈ 5 atol=TOL

            y = Variable(5)
            p = Problem{BigFloat}(:minimize, sum(exp(y)), y>=0)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ 5 atol=TOL
        end

        @testset "log atom" begin
            y = Variable()
            p = Problem{BigFloat}(:maximize, log(y), y<=1)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ 0 atol=TOL

            y = Variable()
            p = Problem{BigFloat}(:maximize, log(y), y<=2)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ log(2) atol=TOL

            y = Variable()
            p = Problem{BigFloat}(:maximize, log(y), [y<=2, exp(y)<=10])
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ log(2) atol=TOL
        end

        @testset "log sum exp atom" begin
            y = Variable(5)
            p = Problem{BigFloat}(:minimize, logsumexp(y), y>=1)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ log(exp(1) * 5) atol=TOL
        end

        @testset "logistic loss atom" begin
            y = Variable(5)
            p = Problem{BigFloat}(:minimize, logisticloss(y), y>=1)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ log(exp(1) + 1) * 5 atol=TOL
        end

        @testset "entropy atom" begin
            y = Variable(5, Positive())
            p = Problem{BigFloat}(:maximize, entropy(y), sum(y)<=1)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ -(log(1 / 5)) atol=TOL
        end

        @testset "relative entropy atom" begin
            x = Variable(1)
            y = Variable(1)
            # x log (x/y)
            p = Problem{BigFloat}(:minimize, relative_entropy(x,y), y==1, x >= 2)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ 2 * log(2) atol=TOL
        end

        @testset "log perspective atom" begin
            x = Variable(1)
            y = Variable(1)
            # y log (x/y)
            p = Problem{BigFloat}(:maximize, log_perspective(x,y), y==5, x <= 10)
            @test vexity(p) == ConvexVexity()
            solve!(p, solver)
            @test p.optval ≈ 5 * log(2) atol=TOL
        end
    end
end
