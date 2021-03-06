using StochasticDiffEq, DiffEqDevTools, Test, Random
using DiffEqProblemLibrary.SDEProblemLibrary: importsdeproblems; importsdeproblems()
import DiffEqProblemLibrary.SDEProblemLibrary: prob_sde_linear
srand(100)
prob = prob_sde_linear

## Solve and plot
println("Solve and Plot")
sol = solve(prob,EM(),dt=1//2^(4))
sol = solve(prob,RKMil(),dt=1//2^(4))
sol = solve(prob,SRI(),dt=1//2^(4))
sol = solve(prob,SRIW1(),dt=1//2^(4))
NUM_MONTE = 100
## Convergence Testing
println("Convergence Test on Linear")
dts = (1//2) .^(9:-1:4) #14->7 good plot with higher num Monte

sim = test_convergence(dts,prob,EM(),numMonte=NUM_MONTE)

sim2 = test_convergence(dts,prob,RKMil(),numMonte=NUM_MONTE)

sim3 = test_convergence(dts,prob,SRI(),numMonte=NUM_MONTE)

#TEST_PLOT && plot(plot(sim),plot(sim2),plot(sim3),layout=@layout([a b c]),size=(1200,600))

@test abs(sim.𝒪est[:l2]-.5) + abs(sim2.𝒪est[:l∞]-1) + abs(sim3.𝒪est[:final]-1.5)<.441  #High tolerance since low dts for testing!

# test reinit
integrator = init(prob,EM(),dt=1//2^(4))
solve!(integrator)
reinit!(integrator)
solve!(integrator)

# test reinit
prob2 = SDEProblem((u,p,t)->prob.f(u,p,t),prob.g,prob.u0,prob.tspan)
integrator = init(prob2,EM(),dt=1//2^(4), tstops = [1//2], saveat = [1//3])
solve!(integrator)
reinit!(integrator)
solve!(integrator)
