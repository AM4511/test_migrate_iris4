J'ai modifie un petit pu le code pour que ca compile sur Iris4

Sur Vivado 2018.2, tapez les commandes suivantes pour creer le projet et block design:

set base_path $env(IRIS4)/athena/XCelerator
source $base_path/XGS12000_XCelerator_src/bd/create_XGS12000_XCelerator.tcl

Pour partir une simulation, Appuyer sur SIMULATION->Run Simulation

