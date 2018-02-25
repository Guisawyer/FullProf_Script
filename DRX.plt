set ylabel "Intensidade(Contagens)" font "Times, 15"  offset 0.5, 0
set xlabel "2{/Symbol q}(°)"  font "Times, 15" offset 0, 0.5


set key center at graph 0.11, 0.73 Left reverse sample 2.0 \
    spacing 1.2

set style line 1 lt 1 lc rgb "#000080" lw 1

set multiplot
set label 1 "Precione 'q' para Sair!" at screen 0.15,0.94
set size 0.4,0.5
set origin 0.58,0.47

set xrange [29.76:33.17]
set xtics 10 in nomirror 
unset ylabel
unset ytics 
set format y ""

plot "DRX.dat"  using 1:2 w l ls 1  title "ZOOM"

set size 1,1
set origin 0,0

set xrange [29.76:33.17]

set ylabel
set ytics 
set format y 

set xtics 10 in nomirror 
plot "DRX.dat"  using 1:2 w l ls 1  title "DRX"

unset multiplot
