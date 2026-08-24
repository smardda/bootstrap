#! /bin/bash
# download version requiring RSA or similar authentication to have been set up
# buildsplitnew.bash <root directory, default smardda> <Y/N, default N for no docm> 
# optional third argument for name of master/main branch.
# Argument to build command below implies get optimised, serial gfortran code
if [ $# -eq 0 ] ; then
SMROOT=$HOME/smardda
else
SMROOT=$HOME/$1
fi
newdoc=N
if [ $# -ge 2 ] ; then
# anything other than Y will prevent doxygen from producing docm
newdoc=$2
#echo "\$newdoc=$newdoc"
fi
BR=master
if [ $# -eq 3 ] ; then
# switch to different branch
BR=$3
fi
# optional version
VERS=
# optional ONE other SMARDDA module repo
EXTRA=
echo "Installation in directory " $SMROOT
echo "Subdirectories smalib and pfc$VERS" 
read -p 'OK? (Y/N): ' isok
if [ "$isok" != "Y" ] ; then exit; fi
if [ ! -d $SMROOT ] ; then mkdir $SMROOT ; fi
cd $SMROOT
# fetch the following repos
SUBDIRS="smalib pfc$VERS $EXTRA"
for i in $SUBDIRS;do mkdir $i; (cd $i; git init);done
echo ""
for i in $SUBDIRS;do (cd $i; git remote add github git@github.com:smardda/$i.git);done
for i in $SUBDIRS;do (cd $i; git pull github);done
export SMALIB_DIR=$SMROOT/smalib
export SMITER_DIR=$SMROOT/pfc$VERS
export EXTRA_DIR=$SMROOT/$EXTRA
# use executables from just fetched
export PATH=$SMITER_DIR/exec:$PATH
# compile and link modules
cd $SMALIB_DIR
git checkout $BR
source ./exec/build gfortran $newdoc
cd $SMITER_DIR
git checkout $BR
source ./exec/build gfortran $newdoc
if [[ -n "$EXTRA_DIR" ]] ; then
  cd $EXTRA_DIR
  git checkout $BR
  cd f95
  # use common configuration
  ln -s $SMALIB_DIR/config/
  # Example of how to make special executables and place with others
  #eg make -f Makefile.test
  #eg mv test $SMITER_DIR/exec
fi
# ensure use just-downloaded version
echo "*****Now type at the terminal:"
echo "export SMROOT=$SMROOT"
echo "export SMALIB_DIR=$SMROOT/smalib"
echo "export SMITER_DIR=$SMROOT/pfc$VERS"
echo "export PATH=\$SMITER_DIR/exec:\$SMALIB_DIR/exec:\$PATH"
