#! /bin/bash
# download version requiring RSA or similar authentication to have been set up
if [ $# -eq 0 ] ; then
SMROOT=$HOME/smardda
else
SMROOT=$HOME/$1
fi
VERS=-new
RADN=pfcr
if [ ! -d $SMROOT ] ; then mkdir $SMROOT ; fi
cd $SMROOT
SUBDIRS="smardda-lib smardda-pfc$VERS $RADN"
#echo $SUBDIRS;exit
for i in $SUBDIRS;do mkdir $i; (cd $i; git init);done
for i in $SUBDIRS;do (cd $i; git remote add ccfe git@git.ccfe.ac.uk:smardda/$i.git);done
for i in $SUBDIRS;do (cd $i; git pull ccfe);done
export SMALIB_DIR=$SMROOT/smardda-lib
export SMITER_DIR=$SMROOT/smardda-pfc$VERS
export RADN_DIR=$SMROOT/$RADN
export PATH=$SMITER_DIR/exec:$PATH
cd $SMALIB_DIR
git checkout master
source ./exec/build N
cd $SMITER_DIR
git checkout main
source ./exec/build N
echo "*****Now type at the terminal:"
echo "export SMALIB_DIR=$SMROOT/smardda-lib"
echo "export SMITER_DIR=$SMROOT/smardda-pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
if [[ -n "$RADN_DIR" ]] ; then
  cd $RADN_DIR
  git checkout main
  cd f95
  ln -s $SMALIB_DIR/config/
  make -f Makefile.antest
  make -f Makefile.powcalr
fi
