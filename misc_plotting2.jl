# using Pkg
# Pkg.activate(".")
## Plotting
using GLMakie, CairoMakie, FileIO, JLD2

# path = "outputs/Cm7hL_20230102"
# model_nm = "MichaelisMenten"

GLMakie.activate!()
fig = Figure(resolution = (1600,1600));

mat = [j > i ? 
        Observable(Matrix{Float64}(undef,π»β[i],π»β[j])) : 
        (j == i ? 
            Observable(Vector{Float64}(undef,π»β[i])) : nothing)
        for i in eachindex(specie), j in eachindex(specie)];

ax = Array{Any}(undef,length(specie),length(specie));

for i in eachindex(specie), j in eachindex(specie)
    if j > i
        ax[i,j] = Axis(fig[i,j])
        heatmap!(ax[i,j],mat[i,j])
    elseif j == i
        ax[i,j] = Axis(fig[i,j],title=specie[i])
        barplot!(ax[i,j],0:(π»β[i]-1),mat[i,j])
        ylims!(ax[i,j],[0 1])
        xlims!(ax[i,j],[0 π»β[i]]);
    end
end
fig

try 
    mkdir(path*"/plots")
catch
    nothing
end

πΌ = zeros(length(π»β),length(T));
πar = zeros(length(π»β),length(T));
β = zeros(length(π»β),length(T),length(π»β));
Sk = zeros(length(π»β),length(T));
π = zeros(1,length(T));
Si = zeros(1,length(T));
Se = zeros(1,length(T));

record(fig, path*"/plots/"*model_nm*"_anim.mp4", eachindex(T);
        framerate = 4) do iT
    iT -= 1;
    global πΌ, πar, β, Sk, π

    flname = path*"/"*model_nm*"_statistics_t"*string(iT);
    data = jldopen(flname);

    specie=data["specie"];
    marg_labels=data["marg_labels"];
    marg=data["marg"];
    πΌ[:,iT+1] = data["E"];
    πar[:,iT+1] = data["Var"];
    β[:,iT+1,:] = data["R"];
    Sk[:,iT+1] = data["Sk"];
    π[1,iT+1] = data["S"];
    Si[1,iT+1] = data["Si"];
    Se[1,iT+1] = data["Se"];
    T = data["T"];

    idm = 1;
    for i in eachindex(specie), j in eachindex(specie)
        if j > i
            mat[i,j][] = marg[idm]'
            idm += 1;
        elseif i == j
            mat[i,j][] = marg[idm];
            idm += 1;
        end
    end 
end

CairoMakie.activate!()
fig2 = Figure(resolution = (300,300));

fig2, ax, sp = series(T,πΌ, labels=specie);
axislegend(ax);
save(path*"/plots/"*model_nm*"_mean_evol.pdf", fig2, pt_per_unit = 2)

fig3 = Figure(resolution = (300,300));

fig3, ax, sp = series(T,[π; Si-Se; Si; Se], labels=["Entropy"; "Entropy change"; "Entropy production"; "Entropy flow"]); 
axislegend(ax);
save(path*"/plots/"*model_nm*"_entrop_evol.pdf", fig3, pt_per_unit = 2)
