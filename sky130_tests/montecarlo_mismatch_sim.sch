v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
B 2 630 -640 1080 -200 {flags=graph,unlocked
y1=-0.03
y2=0.02
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=3000
divx=5
subdivx=1
xlabmag=1.2
ylabmag=1.2
node="vdiff
avg
+3σ; vdiff avg - dup() * avg() sqrt() 3 * avg +
-3σ;vdiff avg - dup() * avg() sqrt() -3 *  avg +"
color="4 7 9 9"
dataset=-1
unitx=1
logx=0
logy=0
sweep=run

sim_type=op
hilight_wave=-1
rawfile=$netlist_dir/montecarlo_mismatch_sim.raw
linewidth_mult=2}
B 2 1090 -640 1540 -200 {flags=graph,unlocked
y1=-0.03
y2=0.02
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=120
divx=5
subdivx=1
xlabmag=1.2
ylabmag=1.2


dataset=-1
unitx=1
logx=0
logy=0

rawfile=distrib
sim_type=distrib


sweep=freq
color=4
node=vdiff
linewidth_mult=4}
P 4 7 330 -250 330 -260 325 -260 330 -270 335 -260 330 -260 330 -250 {fill=full}
P 4 7 330 -250 330 -240 335 -240 330 -230 325 -240 330 -240 330 -250 {fill=full}
T {tcleval(mean=[to_eng $mean]V
σ=[to_eng $rms]V
Samples=$samples)} 930 -190 0 0 0.6 0.6 {layer=4 floater=yes}
T {Vdiff} 270 -260 0 0 0.4 0.4 {}
T {Montecarlo simulation. Get average, stddev and histogram
of OTA differential input voltage mismatch.} 150 -750 0 0 0.7 0.7 {}
N 400 -340 400 -310 {
lab=VDD}
N 400 -190 400 -150 {
lab=GND}
N 240 -270 340 -270 {
lab=VM}
N 240 -450 240 -270 {
lab=VM}
N 240 -450 310 -450 {
lab=VM}
N 370 -450 540 -450 {
lab=#net1}
N 490 -250 540 -250 {
lab=#net1}
N 240 -230 340 -230 {
lab=VCM}
N 240 -230 240 -200 {
lab=VCM}
N 240 -140 240 -100 {
lab=GND}
N 540 -160 540 -120 {
lab=GND}
N 540 -250 540 -220 {
lab=#net1}
N 60 -650 60 -620 {
lab=VDD}
N 60 -560 60 -520 {
lab=GND}
N 540 -450 540 -250 {
lab=#net1}
C {devices/vdd.sym} 400 -340 0 0 {name=l1 lab=VDD}
C {devices/gnd.sym} 400 -150 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} 340 -450 1 1 {name=Vprobe2 value=0 savecurrent=false}
C {devices/vsource.sym} 240 -170 0 1 {name=VICM value="dc 0.85 ac 0" savecurrent=false}
C {devices/gnd.sym} 240 -100 0 0 {name=l4 lab=GND}
C {devices/capa.sym} 540 -190 0 0 {name=C1
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 540 -120 0 0 {name=l5 lab=GND}
C {devices/vdd.sym} 60 -650 0 0 {name=l6 lab=VDD}
C {devices/vsource.sym} 60 -590 0 1 {name=V3 value=1.8 savecurrent=false}
C {devices/gnd.sym} 60 -520 0 0 {name=l7 lab=GND}
C {devices/code.sym} 10 -430 0 0 {name=NGSPICE only_toplevel=false value="
.options savecurrents
.control
 let runs=3000
 let r=0

 dowhile r < runs
   reset
   op
   let vdiff = v(vm,vcm)
   let run=r
   remzerovec
   write OTA_STB_TB_.raw
   set appendwrite
   print v(vm,vcm)
   let r = r + 1
 end

.endc
"}
C {sky130_fd_pr/corner.sym} 10 -230 0 0 {name=CORNER only_toplevel=true corner=tt_mm}
C {devices/launcher.sym} 580 -70 0 0 {name=h15
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/lab_pin.sym} 240 -230 0 0 {name=p2 sig_type=std_logic lab=VCM}
C {devices/title.sym} 160 -30 0 0 {name=l8 author="Nithin P"}
C {sky130_tests/ota1tb.sym} 490 -250 0 0 {name=x2}
C {devices/launcher.sym} 770 -180 0 0 {name=h5
descr="load waves" 
tclcommand="
xschem raw_read $netlist_dir/montecarlo_mismatch_sim.raw op
xschem raw add avg \{vdiff avg()\} run

proc mean \{\} \{
  set vcm [xschem raw value vcm 0]
  set sum 0
  set points [xschem raw points]
  foreach i [xschem raw values vm -1] \{
    set vdiff [expr \{$i - $vcm\}]
    set sum [expr \{$sum + $vdiff\}]
  \}
  set mean [expr \{$sum / $points\}]
  return  $mean
\}

proc variance \{mean\} \{
  set vcm [xschem raw value vcm 0]
  set sum 0
  set points [xschem raw points]
  foreach i [xschem raw values vm -1] \{
    set vdiff [expr \{($i - $vcm - $mean) ** 2\}]
    set sum [expr \{$sum + $vdiff\}]
  \}
  set variance [expr \{$sum / $points\}]
  return  $variance
\}

set mean [mean]
set variance [variance $mean]
set rms [expr \{sqrt($variance)\}]
set samples [xschem raw points]
xschem reset_caches
xschem redraw
"
}
C {devices/launcher.sym} 1310 -180 0 0 {name=h1
descr="Histogram" 

tclcommand="
proc get_histo \{\} \{
  xschem raw switch 0
  set min [expr \{-1./32.\}] ;# this has exact floating point notation
  set max [expr \{1./32.\}]
  proc xround \{a size\} \{ return [expr \{round($a/$size) * $size\}]\}
  #### get rounded data
  set size [expr \{$max / 64.0\}] ;# divide x range into 64 categories
  catch \{unset freq\}
  foreach v1 [xschem raw values vm -1] v2 [xschem raw values vcm -1] \{
    set v1 [expr \{ $v1 - $v2\}]
    set v1 [xround $v1 $size]
    if \{![info exists freq($v1)]\} \{ set freq($v1) 1\} else \{incr freq($v1)\}
  \}
  #### create histogram raw data in memory
  xschem raw new distrib distrib vdiff $min $max $size
  xschem raw add freq
  set j 0
  for \{set i $min\} \{$i <= $max\} \{set i [expr \{$i + $size\}] \} \{
    set v1 0
    if \{[info exists freq($i)]\} \{ set v1 $freq($i) \}
    xschem raw set freq $j $v1
    incr j
  \}
\}
get_histo
xschem draw_graph 1
"
}
C {devices/lab_pin.sym} 240 -270 0 0 {name=p3 sig_type=std_logic lab=VM}