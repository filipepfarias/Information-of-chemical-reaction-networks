# Example of reaction network extracted from 
# Erban and Chapman, on (1.55) and (1.56).

# 3ğ â 2ğ
# 2ğ â 3ğ
# ğ  â â
# â  â ğ

specie = ["A"];

#     ğ
Re = [3;   # Kâ
      2;   # Kâ
      1;   # Kâ
      0];  # Kâ

#     ğ
Pr = [2;   # Kâ
      3;   # Kâ
      0;   # Kâ
      1];  # Kâ

K = [2.5e-4;   # Kâ
     .18;      # Kâ
     37.5;     # Kâ
     2200];    # Kâ
ğ = Pr - Re; # Stoichiometric balance

ğ»â = Tuple(600); # State-space size
A = CMEOperator(ğ,Re,K,ğ»â);

pâ = ones(ğ»â);
# pâ[1] = 1.0;
pâ ./= sum(pâ);