#################################################################
#  Project : Iris4
#  Author: Alain Marchand (amarchan@Matrox.COM)
#  Date: 2020 February 12
#  Last modification: 
#  File: setup_iris4.sh
#################################################################
me=$(readlink --canonicalize --no-newline $BASH_SOURCE)
echo "Running :  $me"
# Assumes that the environment variable IRIS4 is set
if [ -z ${IRIS4+x} ]
then
    echo "Environment variable IRIS4 is unset. Please set it either in Windows or in the current shell";
    return 1
else
    echo "\$IRIS4 set to ${IRIS4}";
fi


# Set the IRIS4 project environment variables
export PROJECT_NAME="iris4"
export ARES=${IRIS4}/ares
export ATHENA=${IRIS4}/athena
export UTIL=${IRIS4}/util

export PATH="$PATH:${UTIL}"
