#set terminal tikz size 9cm, 9cm fontscale 0.9 fulldoc 
#set output "XXXX.tex"
#set xlabel offset  0.0, 0.5 "Sin($\\theta$)"
#set ylabel offset  0.0, 0.0 "B$_rcos(\\theta)\\cdot 10^{-3}$"


set terminal pngcairo enhanced font "Times" fontscale 0.9 size 540,540
set output "XXXX.png"
set ylabel "B_rcos({/Symbol q})" font "Times, 18"  offset 1.10, 0
set xlabel "Sin({/Symbol q})"  font "Times, 18" offset 0, 0.5

set key noautotitles
set decimalsign "," 

set format y "%.2f"
set format x "%.2f"
set style line 1       lc rgb "#0000FF"    lw 2           # Cor da Linha
set style line 2       lc rgb "#006B3C"    lw 2 lt 6      # Cor dos Pontos

L = 0.154056 * 10**(-9)
k= 0.98
f(x) = (a + b*x)*1000
 
fit f(x) "XXXX.txt"  u ($1):($2*1000) via a, b  

set label 1 gprintf("Size = %.2f nm",(k*L/a)*10**(9)) at graph 0.2, 0.9 
set label 2 gprintf("Strain= %.2t \%% ", b*100) at graph 0.2, 0.8
# Para o formato Tikz use estes:
#set label 1 gprintf("$Size = %.2f $ nm",(k*L/a)*10**(9)) at graph 0.2, 0.9 
#set label 2 gprintf("$Strain= %.2t \\%% $ ", b*100) at graph 0.2, 0.8

plot "XXXX.txt"  u ($1):($2*1000) ls 2 , f(x) ls 1  notitle 
