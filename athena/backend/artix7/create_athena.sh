#!/bin/bash
me=$(readlink --canonicalize --no-newline $BASH_SOURCE)
echo "Running $me"

backend_dir="$(dirname $me)"
project_dir="$(readlink --canonicalize ${backend_dir}/..)"
echo "PROJECT_DIR: $project_dir"

vivado_home="/c/Xilinx/Vivado/2019.1"
vivado_cmd="${vivado_home}/bin/vivado"
vivado_version=`${vivado_cmd} -version | head -n1`


echo ${vivado_version}

${vivado_cmd} -mode gui
