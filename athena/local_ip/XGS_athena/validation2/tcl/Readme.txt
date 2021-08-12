This folder contains the scripts for generating a the XGS_athena validation framework (Mono and color configurations)

Files:
Readme.txt                        : This file
create_modelsim_project.tcl       : create the modelsim project
create_modelsim_project_color.tcl : create the modelsim project for the color version of the XGS_athena IP
util.tcl                          : Modelsim utility function for running simulations
util_color.tcl                    : Modelsim utility function for running simulations for the color version
valid.do                          : Script file called by the Modelsim simulation (log the wave, set the simulation ending mode)

To start simulation:
1. Start modelsim
2. In the TCL console :
                source $env(IRIS4)/athena/local_ip/XGS_athena/validation2/tcl/create_modelsim_project.tcl
				or
                source $env(IRIS4)/athena/local_ip/XGS_athena/validation2/tcl/create_modelsim_project_color.tcl

3. Press key h for command help menu
