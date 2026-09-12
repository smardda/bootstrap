#! /bin/bash
# output commands to be typed on command line to change working smardda version
# optionally set VERS version of pfc
# usage pathset.bash [<smardda group name>]
export SMROOT=~/smardda
if [ $# -eq 1 ] ; then
export SMROOT=$HOME/$1
fi
export VERS=
echo "export SMALIB_DIR=$SMROOT/smalib"
echo "export SMITER_DIR=$SMROOT/pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
