#! /bin/bash
# download version requiring RSA or similar authentication to have been set up
# buildsplitnew.bash <root directory, default smardda> <Y/N, default N for no docm> 
if [ $# -eq 0 ] ; then
SMROOT=$HOME/smardda
else
SMROOT=$HOME/$1
fi
newdoc=N
if [ $# -ge 2 ] ; then
# anything other than Y will prevent doxygen from producing docm
newdoc=$2
echo \$newdoc=$newdoc
fi
BR=main
if [ $# -eq 3 ] ; then
# switch to different branch
BR=$3
fi
# "-new" is the UKAEA version without salome
VERS=-new
# radiation version
RADN=pfcr
echo "Installation in directory " $SMROOT
echo "Subdirectories smardda-lib and smardda-pfc$VERS" 
read -p 'OK? (Y/N): ' isok
if [ "$isok" != "Y" ] ; then exit; fi
if [ ! -d $SMROOT ] ; then mkdir $SMROOT ; fi
cd $SMROOT
# fetch the following repos
SUBDIRS="smardda-lib smardda-pfc$VERS $RADN"
for i in $SUBDIRS;do mkdir $i; (cd $i; git init);done
echo ""
for i in $SUBDIRS;do (cd $i; git remote add ccfe git@git.ccfe.ac.uk:smardda/$i.git);done
for i in $SUBDIRS;do (cd $i; git pull ccfe);done
export SMALIB_DIR=$SMROOT/smardda-lib
export SMITER_DIR=$SMROOT/smardda-pfc$VERS
export RADN_DIR=$SMROOT/$RADN
# use executables from just fetched
export PATH=$SMITER_DIR/exec:$PATH
# compile and link modules
cd $SMALIB_DIR
git checkout $BR
source ./exec/build $newdoc
cd $SMITER_DIR
git checkout $BR
source ./exec/build $newdoc
if [[ -n "$RADN_DIR" ]] ; then
  cd $RADN_DIR
  git checkout $BR
  cd f95
  # use common configuration
  ln -s $SMALIB_DIR/config/
  # make special executables and place with others
  make -f Makefile.antest
  make -f Makefile.powcalr
  mv antest powcalr $SMITER_DIR/exec
fi
# ensure use just downloaded version
echo "*****Now type at the terminal:"
echo "export SMROOT=$SMROOT"
echo "export SMALIB_DIR=$SMROOT/smardda-lib"
echo "export SMITER_DIR=$SMROOT/smardda-pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
