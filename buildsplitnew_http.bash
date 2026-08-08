#! /bin/bash
#version requires username and password every time
if [ $# -eq 0 ] ; then
SMROOT=$HOME/smardda
else
SMROOT=$HOME/$1
fi
VERS=-new
mkdir $SMROOT
cd $SMROOT
for i in smardda-lib smardda-pfc$VERS;do git clone https://gitlab.ukaea.uk/smardda/$i.git;done
for i in smardda-lib smardda-pfc$VERS;do (cd $i;git remote add ccfe git@gitlab.ukaea.uk:smardda/$i.git);done
export SMALIB_DIR=$SMROOT/smardda-lib
export SMITER_DIR=$SMROOT/smardda-pfc$VERS
export PATH=$SMITER_DIR/exec:$PATH
cd $SMALIB_DIR
git checkout parallel
source ./exec/build << @@
Y
@@
cd $SMITER_DIR
git checkout parallel
source ./exec/build << @@
Y
@@
echo "*****Now type at the terminal:"
echo "export SMALIB_DIR=$SMROOT/smardda-lib"
echo "export SMITER_DIR=$SMROOT/smardda-pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
