#! /bin/bash
# download version requiring RSA or similar authentication to have been set up
# buildsplitnew.bash <root directory, default smardda> <Y/N, default N for no docm> 
if [ $# -eq 0 ] ; then
SMROOT=$HOME/smardda
else
SMROOT=$HOME/$1
fi
newdoc=N
if [ $# -eq 2 ] ; then
# anything other than Y will prevent doxygen from producing docm
newdoc=$2
fi
VERS=-new
echo "Installation in directory " $SMROOT
echo "Subdirectories smardda-lib and smardda-pfc$VERS" 
read -p 'OK? (Y/N): ' isok
if [ "$isok" != "Y" ] ; then exit; fi
#echo "test OK"
#exit
mkdir $SMROOT
cd $SMROOT
for i in smardda-lib smardda-pfc$VERS;do mkdir $i; (cd $i; git init);done
for i in smardda-lib smardda-pfc$VERS;do (cd $i; git remote add ccfe git@git.ccfe.ac.uk:smardda/$i.git);done
for i in smardda-lib smardda-pfc$VERS;do (cd $i; git pull ccfe);done
export SMALIB_DIR=$SMROOT/smardda-lib
export SMITER_DIR=$SMROOT/smardda-pfc$VERS
export PATH=$SMITER_DIR/exec:$PATH
cd $SMALIB_DIR
git checkout master
source ./exec/build $newdoc
cd $SMITER_DIR
git checkout main
source ./exec/build $newdoc
echo "*****Now type at the terminal:"
echo "export SMALIB_DIR=$SMROOT/smardda-lib"
echo "export SMITER_DIR=$SMROOT/smardda-pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
