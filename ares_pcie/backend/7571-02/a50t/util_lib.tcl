proc get_fpga_build_id { current_time } { 
	################################################
	# BUILD ID generation (timestamp)
	################################################
	#set current_time [clock seconds]
	#set current_time ${build_time}
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
	return ${buildid}

	# ID=0x01  : Spartan6-LX9   GPM - RealTime IO functionnality (Y7449-00)
	# ID=0x02  : Spartan6-LX16  GPM - RealTime IO functionnality (Y7449-01,-02)
	# ID=0x03  : Artix7-35      GPM atom - RealTime IO functionnality (Y7471-00)
	# ID=0x04  : Artix7-50      GPM atom - RealTime IO functionnality with Profinet (Y7471-01)
	# ID=0x05  : Artix7-50      GPM atom - RealTime IO functionnality with Profinet 50 MHz reference NCSI clock (Y7471-02)
	# ID=0x06  : Artix7-50      GPM - RealTime IO functionnality with dual Profinet (Y7449-03)
	# ID=0x07  : Artix7-50      IO board - RealTime IO functionnality with Profinet
	# ID=0x08  : Artix7-35      Iris GTR - RealTime IO functionnality with Profinet (Y7478-00)
	# ID=0x09  : Artix7-35      Eris (spider+profiblaze) version LPC on Iris3 motherboard rev 01
	# ID=0x0A  : Reserved
	# ID=0x0B  : Reserved
	# ID=0x0C  : Reserved
	# ID=0x0D  : Reserved
	# ID=0x0E  : Reserved
	# ID=0x0F  : Reserved
	# ID=0x10  : Artix7-35      Iris GTX - PCIe RealTime IO functionnality with Profinet ()
	# ID=0x11  : Artix7-50      Iris GTX - PCIe RealTime IO functionnality with Profinet ()


}
