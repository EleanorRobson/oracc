#!/bin/sh
project=`oraccopt`

function g2x {
    echo creating $ldir/$l.g2x from $ldir/union.sig
    withall=`oraccopt . cbd-with-all`
    if [ "$withall" = "yes"]; then
	l2p2-g2x.plx -all -h $ldir/union.sig
    else
	l2p2-g2x.plx -h $ldir/union.sig
    fi
#    echo running xisperiods -x 01bld/$l/$l.xis -p $project ...
    xisperiods -x 01bld/$l/$l.xis -p $project >01bld/$l/periods.xis
    if [ -s $ldir/$l.map ]; then
#	echo running l2p2-g2c.plx $l
	l2p2-g2c.plx $l
	export ORACC_HOME
	l2-glomanager.plx -conf l2p2.xcf -cbdlang $l
    else
	echo Glossary $l is empty.  Exterminate.
    fi
}

rm -f 01bld/cancel
super=`oraccopt . cbd-super`
if [ "$super" = "" ]; then
    for l in `l2p2-langs.plx` ; do
	ldir=01bld/$l
	mkdir -p $ldir
	if [ -r 01bld/$l.glo.norm ]; then
	    echo creating $ldir/$l.cbd via 01bld/$l.glo.norm ...
	    l2-glomanager.plx -xml 01bld/$l.glo.norm -out $ldir/$l.cbd
	elif [ -r 00lib/$l.glo ]; then
	    echo creating $ldir/$l.cbd from 00lib/$l.glo ...
	    l2-glomanager.plx -xml 00lib/$l.glo -out $ldir/$l.cbd
	fi
    done
    if [ -e 01bld/cancel ]; then
	echo REBUILD CANCELLED
	exit 1
    fi
    for l in `l2p2-langs.plx` ; do
	ldir=01bld/$l
	mkdir -p 01bld/$l
	[ -r 01bld/project.sig ] && l2p2-sig-slicer.plx -lang $l
	[ -r 01bld/from-glos.sig ] && l2p2-sig-slicer.plx -lang $l -name glossary -sigs 01bld/from-glos.sig
	if [ -r $ldir/glossary.sig ] && [ -r $ldir/$l.sig ]; then
	    l2-sig-union.plx $ldir/$l.sig $ldir/glossary.sig >$ldir/union.sig
	elif [ -r $ldir/glossary.sig ]; then
	    (cd $ldir ; ln -sf glossary.sig union.sig)
	else
	    (cd $ldir; ln -sf $l.sig union.sig)
	fi
	echo creating $ldir/$l.g2x from $ldir/union.sig
	l2p2-g2x.plx -h $ldir/union.sig
#	echo running xisperiods -x 01bld/$l/$l.xis -p $project ...
	xisperiods -x 01bld/$l/$l.xis -p `oraccopt` >01bld/$l/periods.xis
	if [ -s $ldir/$l.map ]; then
#	    echo running l2p2-g2c.plx $l
	    l2p2-g2c.plx $l
	    l2-glomanager.plx -conf l2p2.xcf -cbdlang $l
	else
	    echo Glossary $l is empty.  Exterminate.
	fi
    done
else
    $ORACC/src/misc/l2phase2/l2p2-union.plx
    for a in `ls 01bld/*/union.sig` ; do
	ldir=`dirname $a`
	l=`basename $ldir`
	g2x $ldir $l
    done
fi
usages=`oraccopt . cbd-usages`
if [ "$usages" = "yes" ]; then
    if [ "$project" = "epsd2" ]; then
	00bin/usages.sh
    else
	echo l2p2.sh: "cbd-usages only works with epsd2 at the moment--tell Steve to fix this!"
    fi
fi
