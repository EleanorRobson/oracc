#!/bin/sh
project=`oraccopt`
p3-project-data.plx
xsltproc --stringparam project $project \
    ${ORACC}/lib/scripts/p3-project.xsl $ORACC/lib/data/p3-template.xml | \
    sed -e "s%@@PROJECT@@%$project%" >02www/p3.html
#sed -e "s%@@PROJECT@@%$project%" < $ORACC/lib/data/as-base.xml >02xml/as.xml
