using StochasticDiffEq, Test
using DiffEqProblemLibrary.SDEProblemLibrary: importsdeproblems; importsdeproblems()
import DiffEqProblemLibrary.SDEProblemLibrary: prob_sde_linear, prob_sde_2Dlinear
prob = prob_sde_2Dlinear
choice_function(integrator) = (Int(integrator.t<0.5) + 1)
alg_double = StochasticCompositeAlgorithm((SRIW1(),SRIW1()),choice_function)
alg_double2 = StochasticCompositeAlgorithm((SRI(),SRI()),choice_function)
alg_switch = StochasticCompositeAlgorithm((EM(),RKMil()),choice_function)

srand(100)
@time sol1 = solve(prob_sde_linear,alg_double)
srand(100)
@time sol2 = solve(prob_sde_linear,SRIW1())
@test sol1.t == sol2.t
@test sol1(0.8) == sol2(0.8)

srand(100)
integrator1 = init(prob,alg_double2)
srand(100)
integrator2 = init(prob,SRI())
srand(100)
solve!(integrator1)
srand(100)
solve!(integrator2)

@test integrator1.sol.t == integrator2.sol.t

sol = solve(prob,alg_switch,dt=1/8)
