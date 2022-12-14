using CME

model_nm = "MichaelisMenten"
model = "reactions/"*model_nm*".jl";
include(model);

pS = pโ;
p = pโ;
sim = 0; max_sim = 5000;

while sim < max_sim
    ๐ฎ = [rand(โฐ),โฐ๐,rand(๐),โฌ]' .-1;
    t,S = Gillespie(K, ๐, Re, ๐ฎ, T[35]);
    pS[(S .+ 1)...] = 1;
    p += pS;
    pS[(S .+ 1)...] = 0;

    sim += 1;
end

p = p ./ sum(p);

# A = CMEOperator(๐,Re,K,๐ปโ); 
marg_labels, marg, ๐ผ, ๐ar, โ, Sk, ๐, Si, Se = CMEStatistics(p[:],A,๐ปโ,specie);

# heatmap(marg[10]')
barplot(marg[10])

# it = (T[1:end-1] .<= t') .& (T[2:end] .>= t');