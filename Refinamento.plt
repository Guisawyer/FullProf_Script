set terminal pngcairo enhanced font "Times" fontscale 0.9 size 960,540
set output "2080a.png"


set ylabel "Intensidade(Contagens)" font "Times, 18"  offset 1.10, 0
set xlabel "2{/Symbol q}(°)"  font "Times, 18" offset 0, 0.5
set xrange [84.0:86]
set yrange [84.0:86]
set ytics in nomirror 
#set format y ""
set xtics 10 in nomirror 
set key center at graph 0.11, 0.87 Left reverse sample 2.0 \
    spacing 1.2

set style line 1 lt 6 lc rgb "#FF4500"
set style line 2 lt 1 lc rgb "#000000" lw 2
set style line 3 lt 1 lc rgb "#000080" lw 1


set multiplot

plot "BTNN20_80.pl1"  using 1:2 ls 1  title "Obs" , '' using 1:3 w l ls 2  title "Calc", '' using 1:($4) w l ls 3  title "(Obs - Calc)", "BTNN20_80.pl2" using 1:($2)  linetype -1 pointtype "|" tc rgb "#E32636" title "{/:Italic P4mm}"

set size 0.4,0.5
set origin 0.58,0.47
#Fazendo o ZOOM!!
set xlabel "2{/Symbol q}(°)"  font "Times, 15" offset 0, 0.5
set xrange [84.0:86]
set xtics 10 in nomirror 
unset ylabel
unset ytics 
set format y ""

plot "BTNN20_80.pl1"  using 1:2 ls 1  notitle , '' using 1:3 w l ls 2  notitle , '' using 1:($4+3400) w l ls 3  notitle , "BTNN20_80.pl2" using 1:($2)  linetype -1 pointtype "|" tc rgb "#E32636" notitle

unset multiplot
