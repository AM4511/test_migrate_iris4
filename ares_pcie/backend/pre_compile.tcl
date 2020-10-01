
################################################
# BUILD ID generation (timestamp)
################################################
set current_time [clock seconds]
puts stdout [clock format $current_time]

# l'année est en HEX sur 2 chiffres
set annee_s [string trimleft [clock format $current_time -format "%y"] "0"]
set annee [expr $annee_s]
set annee_hex [expr $annee + (($annee/10)*6)]

set mois_s [string trimleft [clock format $current_time -format "%m"] "0"]
set mois [expr $mois_s]

set jour_s [string trimleft [clock format $current_time -format "%d"] "0"]
set jour [expr $jour_s]
set jour_hex [expr $jour + (($jour/10)*6)]

set heure_s [string trimleft [clock format $current_time -format "%H"] "0"]

# Taking care of case 0 hour
if [string match "" $heure_s] {
    set heure_hex {0}
} else {
    set heure_hex [expr $heure_s + (($heure_s/10)*6)]
}

set minute_s [string trimleft [clock format $current_time -format "%M"] "0"]

# Taking care of case 0 minute
if [string match "" $minute_s] {
    set min_hex {0}
} else {
    set min_hex [expr ($minute_s/10)]
}

#format pour 100 ans:  aaMjjhhm ou M est le mois en hex, m est les dizaines de minutes, le reste est en BCD.
set buildid [expr $annee_hex * 0x1000000 + $mois * 0x00100000 + $jour_hex * 0x1000 + $heure_hex * 0x10 + $min_hex]
#set buildid [expr 0x12345678]
puts stdout [format "Build ID: 0x%08x" $buildid]


# ID=1  : Spartan6-LX9   GPM - RealTime IO functionnality (Y7449-00)
# ID=2  : Spartan6-LX16  GPM - RealTime IO functionnality (Y7449-01,-02)
# ID=3  : Artix7-35      GPM atom - RealTime IO functionnality (Y7471-00)
# ID=4  : Artix7-50      GPM atom - RealTime IO functionnality with Profinet (Y7471-01)
# ID=5  : Artix7-50      GPM atom - RealTime IO functionnality with Profinet 50 MHz reference NCSI clock (Y7471-02)
# ID=6  : Artix7-50      GPM - RealTime IO functionnality with dual Profinet (Y7449-03)
# ID=7  : Artix7-50      IO board - RealTime IO functionnality with Profinet
# ID=8  : Artix7-35      Iris GTR - RealTime IO functionnality with Profinet (Y7478-00)
# ID=9  : Artix7-35      Eris (spider+profiblaze) version LPC on Iris3 motherboard rev 01


#savoir la grandeur du FPGA, a partir du device (hardcode Artix-7 ici)
regexp xc7a([0-9]+)t [get_property part [current_project]] dummy_var device_number
#if {$device_number == 35} {
#  set fpga_id {3}
#} elseif {$device_number == 50} {
  # malheureusement, il y a maintenant plusieurs ID pour la meme dimension de FPGA
#  if {[info exists fpga_id]} {
#    puts stdout [format "FPGA ID est deja defini, pas besoin de le detecter: 0x%01x" $fpga_id]
#} else {
    # la variable n'existe pas, ca doit etre parce que on ne vient pas de creer le projet, on a recharge le projet
#    set generique [ report_property -return_string [current_fileset] GENERIC ]
#    if {[regexp {(FPGA_ID=)(.)} $generique match idstring fpga_id]} {
#      puts stdout [format "FPGA ID read from generic string is: %s" $fpga_id]
#    } else {
#      puts "Le FPGA_ID n'existe pas en variable TCL et n'est pas defini dans la chaine generique. SVP determiner la variation de FPGA avec 'set fpga_id 4' (pour Y7471-01) , 'set fpga_id 5' pour les pcb y7472-02 ou 'set fpga_id 6' pour les pcb y7449-03" 
#      return
#    }
#}
#} else {
#  puts "numero de piece pas supporte par notre .TCL, fpga_id sera incorrect!"
#}
puts stdout [format "FPGA ID: 0x%01x" $fpga_id]

#le FPGA_ID est hardcode dans le fichier TOP VHDL car il doit etre different pour chaque ID, donc plus necessaire (pour l'instant) de le detecter ou changer par script.

# Setting BUILD_ID value in GENERIC in order to pass it to VHDL
set_property generic "FPGA_ID=$fpga_id BUILD_ID=32'h[format "%08x" $buildid]"  [current_fileset]
#set_property generic "BUILD_ID=32'h[format "%08x" $buildid]"  [current_fileset]

puts stdout [format "You can now source compile.tcl" ]
