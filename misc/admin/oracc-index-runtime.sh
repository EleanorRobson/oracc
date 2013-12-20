#!/bin/sh
PROG=oracc-index-runtime.sh
if [ "$project" == "" ]; then
    project=$1
    if [ "$project" == "" ]; then
	echo $PROG: must give project on command line. Stop.
	exit 1
    fi
fi
dir=$ORACC/pub/$project
if [ -s $ORACC/bld/$project/cdlicat.xmd ]; then
    mkdir -p $dir/cat
    secatx -s -p $project < $ORACC/bld/$project/cdlicat.xmd
fi
if [ -s $ORACC/bld/$project/lists/xtfindex.lst ]; then
    mkdir -p $dir/tra
    cat 01bld/lists/xtfindex.lst | setrax -p $project
    mkdir -p $dir/txt
    cat 01bld/lists/xtfindex.lst | setxtx -p $project
fi
if [ -s $ORACC/bld/$project/lists/lemindex.lst ]; then
    mkdir -p $dir/lem
    cat 01bld/lists/lemindex.lst | selemx -p $project
fi
pgcsi $ORACC/bld/$project/sortinfo.tab
mv $ORACC/bld/$project/sortinfo.csi $dir
