#################################################################
#  Project : Iris4
#  Author: Alain Marchand (amarchan@Matrox.COM)
#  Date: 2020 February 12
#  Last modification: 
#  File: setup_iris4.sh
#################################################################
me=$(readlink --canonicalize --no-newline $BASH_SOURCE)
echo "Running :  $me"


#################################################################
# Assumes that the environment variable IRIS4 is set. If not
# propose to set it.
#################################################################
if [ -z ${IRIS4+x} ]
then
    backend_dir="$(dirname $me)"
    project_dir="$(readlink --canonicalize ${backend_dir}/..)"
  
    echo ""
    echo "Environment variable IRIS4 is unset."
    printf "Do you want to set it to: ${project_dir} ? [y/n] : "
    read answer
    if [ $answer == "y" ]
    then
	export IRIS4=${project_dir}
    else
	echo "Error : IRIS4 not set! Please set the environment variable IRIS4"
	return 1
    fi
fi

echo ""
echo "\$IRIS4 set to ${IRIS4}";


#################################################################
# Set the IRIS4 project environment variables
#################################################################
export PROJECT_NAME="iris4"
export ARES="${IRIS4}/ares_pcie"
export ATHENA="${IRIS4}/athena"
export UTIL="${IRIS4}/util"

export PATH="$PATH:${UTIL}"


#################################################################
# Set the IRIS4 project aliases
#################################################################
alias ares='cd ${ARES}'
alias athena='cd ${ATHENA}'
alias util='cd ${UTIL}'


