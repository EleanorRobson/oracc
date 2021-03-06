#!/bin/sh
[ -r 01bld/cancel ] && exit 1
shopt -s nullglob
webdir=01bld/www ; rm -fr $webdir
mkdir -p $webdir/t $webdir/cbd $webdir/css
cp 02xml/config.xml $webdir/config.xml
cp 00lib/thumb.png $webdir/thumb.png
if [ -r 00lib/project.sty ]; then
    cp -p 00lib/project.sty $webdir/
fi
p3-colours.plx $webdir
otl=`oraccopt . outline-special-list-name`
if [ "$otl" != "" ]; then
    if [ -r 00lib/$otl ]; then
	echo processing 00lib/$otl
	o2-list-default-project.sh `oraccopt` 00lib/$otl $webdir/lists/$otl
	chmod o+r $webdir/lists/$otl
    else
	echo no such file 00lib/$otl
    fi
fi
mkdir -p $webdir/lists
if [ -d 00lib/lists ]; then
    liblists=`(cd 00lib/lists ; ls)`
    if [ "$liblists" != "" ]; then
	cp -f 00lib/lists/* $webdir/lists
    fi
fi
if [ -d 01bld/lists ]; then
    bldlists=`(cd 01bld/lists ; ls)`
    if [ "$bldlists" != "" ]; then
	for a in `ls 01bld/lists/* | egrep -v '.lst$'` ; do
	    cp -f $a $webdir/lists
	done
    fi
fi
if [ -r 01bld/lists/outlined.lst ]; then
    cp -f 01bld/lists/outlined.lst $webdir/lists
fi
l2p3.sh $webdir
if [ -f 01bld/lists/have-xtf.lst ]; then
    web-PQX-html.plx -list 01bld/lists/have-xtf.lst -proj `oraccopt` 2>01tmp/web-PQX.log
    clean-web-PQX-log.sh
fi
o2-portal.sh
