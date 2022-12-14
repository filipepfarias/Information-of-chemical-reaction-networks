# Michaelis-Menten mechanism extracted from
# Qian and Ge on (9.1).

# â° + ğ  â â°ğ
# â°ğ     â â° + ğ
# â°ğ     â â° + â¬

specie = ["E", "EA", "EB", "A", "B"];

#     â° â°ğ â°â¬ ğ  â¬ 
Re = [1  0  0  1  0; # kâ
      0  1  0  0  0; # kââ
      0  1  0  0  0; # kâ
      0  0  1  0  0; # kââ
      0  0  1  0  0; # kâ
      1  0  0  0  1; # kââ
      0  0  0  0  0; # kâ
      0  0  0  1  0; # kââ
      0  0  0  0  0; # kâ
      0  0  0  0  1; # kââ
      0  0  0  0  0; # kâ
      0  1  0  0  0; # kââ
      0  0  0  0  0; # kâ
      0  0  1  0  0; # kââ
]
#     â° â°ğ â°â¬ ğ  â¬ 
Pr = [0  1  0  0  0; # kâ
      1  0  0  1  0; # kââ
      0  0  1  0  0; # kâ
      0  1  0  0  0; # kââ
      1  0  0  0  1; # kâ
      0  0  1  0  0; # kââ
      0  0  0  1  0; # kâ
      0  0  0  0  0; # kââ
      0  0  0  0  1; # kâ
      0  0  0  0  0; # kââ
      0  1  0  0  0; # kâ
      0  0  0  0  0; # kââ
      0  0  1  0  0; # kâ
      0  0  0  0  0; # kââ
]

# Deterministic to stochastic rate conversion
# k1 = 1 Ã 10â¶, k2 = 1 Ã 10â»â´, k3 = 0.1
# From Wilkinson, Stochastic Modelling for
# System Biology
V   = 5e-17;                 # Original 1e-15
nâ  = 6.022e23;              # Avogadro's number
kâ  = 1e6 / nâ / V;          # 2nd order reaction
kââ = 1e-4;                  # 1st order reaction 
kâ  = 0.01;                    
kââ  = 0.01;                   
kâ = 0.1;
kââ = 0.01;
kâ = kââ = kâ = kââ = kâ = kââ = kâ = kââ = 0.0;

K = [kâ; kââ; kâ; kââ; kâ; kââ; kâ; kââ;
     kâ; kââ; kâ; kââ; kâ; kââ;
     ]; 

# Initial conditions
â°, â°ğ, â°â¬, ğ, â¬ = V * nâ .* (2e-7, 0, 0, 0, 5e-7);
â°, â°ğ, â°â¬, ğ, â¬ = floor.(Int,(â°, â°ğ, â°â¬, ğ, â¬)) .+ 1; # Convertion to state-space index
â°, â°ğ, â°â¬, ğ, â¬ = (â°-2:â°+2, â°ğ, â°â¬, ğ, â¬-2:â¬+2)

ğ = Pr - Re;                  # Stoichiometric balance

n = maximum(maximum.((â°, â°ğ, â°â¬, ğ, â¬)));
ğ»â = (n,n,n,n,n);                # State-space size

pâ = zeros(ğ»â);                # Initial condition for Section 7.3
pâ[â°, â°ğ, â°â¬, ğ, â¬] .= 1.0;
# pâ[â°, â°ğ, ğ, â¬] = 1.0;
pâ ./= sum(pâ);

# pâ = ones(ğ»â);              # Uniform distribution
# pâ ./= sum(pâ); 
# pâ[end] = 1 - sum(pâ[1:end-1]);

A = CMEOperator(ğ,Re,K,ğ»â);   # CME Operator      