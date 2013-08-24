#!/bin/sh

function quit {
    echo install-oracc-vhost-conf.sh: $1. Stop.
    exit 1
}

if [ -r /etc/httpd/httpd.conf ]; then
    HTTPD_CONF=/etc/httpd/httpd.conf
else
    if [ -r /private/etc/apache2/httpd.conf ]; then
	HTTPD_CONF=/private/etc/apache2/httpd.conf
    else
	quit "unable to locate httpd.conf"
    fi
fi
grep -q oracc-vhost $HTTPD_CONF && quit "oracc-vhost is already in httpd.conf"
if [ -d /etc/httpd/conf ]; then
    HTTPD_CONFDIR=/etc/httpd/conf
    HTTPD_VDIR=/etc/httpd/conf
else
    if [ -d /private/etc/apache2/other ]; then
	HTTPD_CONFDIR=/private/etc/apache2
	HTTPD_VDIR=/private/etc/apache2/other
    else
	quit "unable to locate httpd configuration directory"
    fi
fi
INSTDIR=`pwd`
cd $HTTPD_CONFDIR || quit "unable to change directory to $HTTPD_CONFDIR"
cp -a $HTTPD_CONF oracc-saved-$HTTPD_CONF || quit "unable to save backup copy of $HTTPD_CONF"
cp -a $INSTDIR/oracc-vhost.conf . || quit "unable to install oracc-vhost.conf"
cat >>$HTTPD_CONF <<EOF
NameVirtualHost *:80
include $HTTPD_VDIR/oracc-vhost.conf
EOF
apachectl -t || quit "Please correct the problems with httpd.conf then type: apachectl restart"
echo You may now restart the webserver by typing: apachectl restart
