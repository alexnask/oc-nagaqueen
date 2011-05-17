#!/bin/bash
export OOC_LIBS=..

mkdir -p bin .libs

if [[ ! -e $PREFIX ]]; then
    export PREFIX=$PWD/prefix
    mkdir -p $PREFIX
fi

if [[ ! -e $LIBDIR ]]; then
    export LIBDIR=$PREFIX/lib
    mkdir -p $LIBDIR
fi

echo Library directory is $LIBDIR

if [[ ! -e $NAGAQUEEN_DIST ]]; then
    export NAGAQUEEN_DIST=../nagaqueen
fi

if [[ ! -e .libs/NagaQueen.o ]]; then
  echo "Compiling nagaqueen"
  greg $NAGAQUEEN_DIST/grammar/nagaqueen.leg > .libs/NagaQueen.c || exit
  gcc -fPIC -w -c -std=c99 -D__OOC_USE_GC__ .libs/NagaQueen.c -O3 -o .libs/NagaQueen.o $C_FLAGS || exit 1
  rock -v -libfolder=$NAGAQUEEN_DIST/source .libs/NagaQueen.o -dynamiclib=$LIBDIR/libnagaqueen.so || exit 1
fi

OC_DIST=../oc
OOC_FLAGS="-v -g -nolines +-rdynamic"

mkdir -p $OC_DIST/plugins
rock $OOC_FLAGS -packagefilter=frontend/nagaqueen/ -dynamiclib=$OC_DIST/plugins/nagaqueen_frontend.so -sourcepath=source frontend/nagaqueen/Frontend
