#! /bin/bash
# download version requiring RSA or similar authentication to have been set up
if [ $# -eq 0 ] ; then
SMROOT=$HOME/smardda
else
SMROOT=$HOME/$1
fi
# "-new" is the UKAEA version without salome
VERS=-new
# radiation version
RADN=pfcr
if [ ! -d $SMROOT ] ; then mkdir $SMROOT ; fi
cd $SMROOT
# fetch the following repos
SUBDIRS="smardda-lib smardda-pfc$VERS $RADN"
for i in $SUBDIRS;do mkdir $i; (cd $i; git init);done
for i in $SUBDIRS;do (cd $i; git remote add ccfe git@git.ccfe.ac.uk:smardda/$i.git);done
for i in $SUBDIRS;do (cd $i; git pull ccfe);done
export SMALIB_DIR=$SMROOT/smardda-lib
export SMITER_DIR=$SMROOT/smardda-pfc$VERS
export RADN_DIR=$SMROOT/$RADN
# use executables from just fetched
export PATH=$SMITER_DIR/exec:$PATH
# compile and link modules
cd $SMALIB_DIR
git checkout main
source ./exec/build N
cd $SMITER_DIR
git checkout main
source ./exec/build N
if [[ -n "$RADN_DIR" ]] ; then
  cd $RADN_DIR
  git checkout main
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
echo "****For long term use, add to .bashrc"
