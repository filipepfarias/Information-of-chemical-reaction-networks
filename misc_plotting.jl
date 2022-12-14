# using Pkg
# Pkg.activate(".")
## Plotting
using GLMakie, CairoMakie, FileIO, JLD2

path = "outputs/gv4Yl_20221117"
model_nm = "MichaelisMenten"

# For Michaelis-Menten reaction network
GLMakie.activate!()
fig = Figure(resolution = (1000,1000));

mat = [j > i ? 
        Observable(Matrix{Float64}(undef,ð»â[i],ð»â[j])) : 
        (j == i ? 
            Observable(Vector{Float64}(undef,ð»â[i])) : nothing)
        for i in eachindex(specie), j in eachindex(specie)];

ax = Array{Any}(undef,length(specie),length(specie));

for i in eachindex(specie), j in eachindex(specie)
    if j > i
        ax[i,j] = Axis(fig[i,j])
        heatmap!(ax[i,j],mat[i,j])
    elseif j == i
        ax[i,j] = Axis(fig[i,j],title=specie[i])
        barplot!(ax[i,j],0:(ð»â[i]-1),mat[i,j])
        ylims!(ax[i,j],[0 1])
        xlims!(ax[i,j],[0 ð»â[i]]);
    end
end
fig

try 
    mkdir(path*"/plots")
catch
    nothing
end

record(fig, path*"/plots/"*model_nm*"_anim.mp4", eachindex(T);
        framerate = 4) do iT
    iT -= 1;
    flname = path*"/"*model_nm*"_t"*string(iT)*"_marg_";
    for i in eachindex(specie), j in eachindex(specie)
        if j > i
            flsuffix = specie[i]*"_x_"*specie[j];
            mat[i,j][] = jldopen(flname*flsuffix)["p"]
        elseif i == j
            flsuffix = specie[i];
            ind = collect(eachindex(specie))
            mat[i,j][] = jldopen(flname*flsuffix)["p"];
        end
    end 
end

CairoMakie.activate!()
fig2 = Figure(resolution = (300,300));

flname = path*"/"*model_nm*"_mean";
ð¼ = jldopen(flname)["E"];
T = jldopen(flname)["T"];

fig2, ax, sp = series(T,ð¼, labels=specie);
axislegend(ax);
save(path*"/plots/"*model_nm*"_mean_evol.pdf", fig2, pt_per_unit = 2)

fig3 = Figure(resolution = (300,300));

flname = path*"/"*model_nm*"_entropy";
ð = jldopen(flname)["S"];
dðdt = jldopen(flname)["dSdt"];

fig3, ax, sp = series(T,[ð;dðdt; 0 diff(ð[:])'], labels=["Entropy","Entropy balance","Test"]); 
axislegend(ax);
save(path*"/plots/"*model_nm*"_entrop_evol.pdf", fig3, pt_per_unit = 2)
