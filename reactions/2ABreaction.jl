# Example of reaction network extracted from 
# Erban and Chapman, on (1.55) and (1.56).

# 2ğ     â â
# ğ + â¬ â â
# â      â ğ
# â      â â¬

specie = ["A", "B"];

#     ğ  â¬
Re = [2  0;   # Kâ
      1  1;   # Kâ
      0  0;   # Kâ
      0  0];  # Kâ

#     ğ  â¬
Pr = [0  0;   # Kâ
      0  0;   # Kâ
      1  0;   # Kâ
      0  1];  # Kâ

K = [1e-3;  # Kâ
     1e-2;  # Kâ
     1.2;   # Kâ
     1];    # Kâ
ğ = Pr - Re; # Stoichiometric balance

ğ»â = (25,25); # State-space size

T = 0.0:.4:100.0;

pâ = zeros(ğ»â);
pâ[1,1] = 1.0;
pâ ./= sum(pâ);