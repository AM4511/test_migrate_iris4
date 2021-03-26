# ##################################################################################
# File         : firmwares.tcl
# Description  : This TCL script creates the Athena fpga firmwares. 
# Example      : source $env(IRIS4)/athena/backend/artix7/firmwares.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set SYNTH_RUN [current_run -synthesis]
set IMPL_RUN  [current_run -implementation]
set DEVICE    [get_property part [current_project]]

open_run $IMPL_RUN


# Extracting the Working directory
set PROJECT_DIRECTORY      [get_property DIRECTORY [current_project]]
set OUTPUT_BASE_DIR        "${PROJECT_DIRECTORY}/output"
set OUTPUT_DIR             ${OUTPUT_BASE_DIR}

# Extract the current project top design name
set design_name [current_project]
set top_entity_name [get_property top [current_fileset]]


#savoir la grandeur du FPGA, a partir du device (hardcode Artix-7 ici)
regexp xc7a([0-9]+)t [get_property part [current_project]] dummy_var device_number

# Allons chercher le BUILD_ID
set buildid_generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_BUILD_DATE=*"]
set buildid [regsub -nocase "FPGA_BUILD_DATE=" $buildid_generic "" ]
puts stdout [format "Build date is: 0x%s" $buildid]

# Extract the FPGA Major version
set generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_MAJOR_VERSION=*"]
set MAJOR [regsub -nocase "FPGA_MAJOR_VERSION=" $generic "" ]

# Extract the FPGA Minor version
set generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_MINOR_VERSION=*"]
set MINOR [regsub -nocase "FPGA_MINOR_VERSION=" $generic "" ]


# Extract the FPGA Sub-Minor version
set generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_SUB_MINOR_VERSION=*"]
set SUB_MINOR [regsub -nocase "FPGA_SUB_MINOR_VERSION=" $generic "" ]

set FPGA_VERSION "${MAJOR}.${MINOR}.${SUB_MINOR}"


set FPGA_DESCRIPTION "IrisGTX Athena FPGA"
set YEAR [clock format [clock seconds] -format {%Y}]
set BUILD_DATE [clock format ${buildid} -format "%Y-%m-%d  %H:%M:%S"]
set VIVADO_SHORT_VERSION [version -short]


cd $PROJECT_DIRECTORY
pwd

set id 0
while {$id < 20} {
	
	set OUTPUT_DIR "${OUTPUT_BASE_DIR}/run_${id}"
	if { [file exist $OUTPUT_DIR] } {
		set id [expr $id + 1]
		} else {
		file mkdir ${OUTPUT_DIR}
			puts "Creating $OUTPUT_DIR"
			break
		}
} 

# Generates ILA probes (chipscope)
write_debug_probes -force $OUTPUT_DIR/ila_probes.ltx


set UPGRADE_BASE_NAME             $OUTPUT_DIR/${design_name}
set UPGRADE_BIT_FILENAME          ${UPGRADE_BASE_NAME}.bit
set UPGRADE_BIN_FILENAME          ${UPGRADE_BASE_NAME}.bin
set UPGRADE_MCS_FILENAME          ${UPGRADE_BASE_NAME}.mcs
set UPGRADE_FIRMWARE_FILENAME     ${UPGRADE_BASE_NAME}.firmware


# Set the firmware type for the .firmware file (UPGRADE or GOLDEN)
set FIRMWARE_TYPE  "UPGRADE"
if {${FPGA_IS_NPI_GOLDEN} eq "true"} {
  puts "### Generating NPI upgrade firmware ###"
  set FIRMWARE_TYPE  "GOLDEN"
  set_property BITSTREAM.CONFIG.NEXT_CONFIG_ADDR ${NEXT_CONFIG_ADDR} [current_design]

}

# Create upgrade firmware
write_bitstream -force $UPGRADE_BIT_FILENAME

# Create the .mcs version
write_cfgmem -force -format MCS -size 8 -interface SPIx4 -checksum  -loadbit "up ${FLASH_OFFSET} ${UPGRADE_BIT_FILENAME} " ${UPGRADE_MCS_FILENAME}

# Create the .bin version
write_cfgmem -force -format BIN -size 8 -interface SPIx4 -checksum  -loadbit "up ${FLASH_OFFSET} ${UPGRADE_BIT_FILENAME} " ${UPGRADE_BIN_FILENAME}


# ####################################################################################
# Generate .firmware
# ####################################################################################
set INFILE [open ${UPGRADE_MCS_FILENAME} r]
set OUTFILE [open ${UPGRADE_FIRMWARE_FILENAME} w]

puts $OUTFILE "Copyright (c) 1995-${YEAR} Matrox Electronic Systems Ltd."
puts $OUTFILE "All Rights Reserved."
puts $OUTFILE "";
puts $OUTFILE "$FPGA_DESCRIPTION"
puts $OUTFILE "FPGA Version   : $FPGA_VERSION"
puts $OUTFILE "BuildID        : $buildid"
puts $OUTFILE "Build date     : $BUILD_DATE"
puts $OUTFILE "Vivado version : $VIVADO_SHORT_VERSION"
puts $OUTFILE "Device         : $DEVICE"
puts $OUTFILE "Firmware type  : ${FIRMWARE_TYPE}"
puts $OUTFILE "Flash offset   : ${FLASH_OFFSET}"


# Generic section
puts $OUTFILE "\n";
puts $OUTFILE "MCS="

while { [gets $INFILE line] >= 0 } {
    puts $OUTFILE $line
}

close $INFILE
close $OUTFILE
