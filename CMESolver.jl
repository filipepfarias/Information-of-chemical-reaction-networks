# using Pkg
# Pkg.activate(".")
# Pkg.instantiate();

using CME
using Random, Dates, FileIO, JLD2
using DifferentialEquations: solve, ODEProblem, RK4
using ProgressMeter

path = "outputs/"*randstring(5)*"_"*Dates.format(now(),"yyyymmdd")
mkdir(path)

println("Building the CME operator...")
comp_time = @elapsed begin
    model_nm = "MichaelisMenten"
    model = "reactions/"*model_nm*".jl";
    include(model);
    A = CMEOperator(π,Re,K,π»β);   # CME Operator      
    cp(model,path*"/model.jl")
end
println("Computation time for the assemble of the operator: "*string(comp_time)*"s.")

f(u,p,t) = A*u ;

uf = pβ[:];
p = uf;

# flname = path*"/"*model_nm*"_t"*string(iT);
# jldsave(flname, p=uf, t=0)

# pf = zeros(length(uf),length(T));

marg_labels, marg, πΌ, πar, β, Sk, π, Si, Se = CMEStatistics(uf,A,π»β,specie);

println("Saving on "*path*".")

flname = path*"/"*model_nm*"_statistics_t"*string(0);
jldsave(flname, specie=specie,
    marg_labels=marg_labels, 
    marg=marg, E=πΌ, Var=πar, R=β, Sk=Sk, S=π, Si=Si, Se=Se, t=0, T=T)
# pf[:,1] = uf;

pgres = Progress(length(T)-1; showspeed=true, desc="Solving the CME...")

for iT in eachindex(T)[1:end-1]
    global pf, uf, flname, marg_labels, marg, πΌ, πar, β, Sk, π, Si, Se, sol
    prob = ODEProblem(f,uf, (T[iT],T[iT+1]));
    sol = solve(prob, RK4();dt= .5/20, saveat=T[iT+1],adaptive=false);
    uf = sol.u[end]/sum(sol.u[end]);
    # u0 = sol.u[end]
    # pf[:,iT+1] = uf;

    # flname = path*"/"*model_nm*"_t"*string(iT);
    # jldsave(flname, p=uf, t=T[iT+1])
    marg_labels, marg, πΌ, πar, β, Sk, π, Si, Se = CMEStatistics(uf,A,π»β,specie)

    flname = path*"/"*model_nm*"_statistics_t"*string(iT);
    jldsave(flname, specie=specie,
    marg_labels=marg_labels, 
    marg=marg, E=πΌ, Var=πar, R=β, Sk=Sk, S=π, Si=Si, Se=Se, t=T[iT], T=T)

    ProgressMeter.next!(pgres)
end

# Q = A - diagm(diag(A)); 
# Si = [ .5* sum( (A*diagm(pf[:,iT]) - (A'*diagm(pf[:,iT]))') .* (log.(Q * diagm(pf[:,iT])) .* .!isinf.(log.(Q * diagm(pf[:,iT]))) - log.(Q' * diagm(pf[:,iT]))' .* .!isinf.(log.(Q' * diagm(pf[:,iT])))' ) )  for iT in eachindex(T)]
# Se = [ .5* sum( (A*diagm(pf[:,iT]) - (A'*diagm(pf[:,iT]))') .* (log.(Q) .* .!isinf.(log.(Q)) - log.(Q')' .* .!isinf.(log.(Q'))' ) )  for iT in eachindex(T)]


# Plotting
# println("Saving plots...")
include("misc_plotting2.jl")
