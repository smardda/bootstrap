#! /bin/bash
# output commands to be typed on command line to change working smardda version
# setting VERS=-new gets SMARDDA-PFC w/o Python GUI
# usage pathset.bash [<smardda group name>]
export SMROOT=~/smardda-test
if [ $# -eq 1 ] ; then
export SMROOT=$HOME/$1
fi
export VERS=-new
echo "export SMALIB_DIR=$SMROOT/smardda-lib"
echo "export SMITER_DIR=$SMROOT/smardda-pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
