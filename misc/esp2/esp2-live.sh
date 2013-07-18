# 
# XML Site Architecture Project
# George MacKerron 2005
#
# Adapted for Oracc by Steve Tinney, 2010
#

if [ "$1" = "" ]; then
    echo esp-live.sh: must give project name as first argument
    exit 1
fi

#if [ "$2" = "" ]; then
#    echo esp-live.sh: must give webdir name as second argument
#    exit 1
#else
#    echo esp-live.sh: forcing webdir to 01bld/www
#    webdir=01bld/www
#fi

if [ ! -d 01tmp/dev ]; then
    echo esp-live.sh: nothing to copy--expected to find website in 01tmp/dev
    exit 1
fi

if [ "$2" != "" ]; then
    if [ "$2" = "force" ]; then
	force=yes
    else
	echo esp-live.sh: third argument may only be 'force'
	exit 1
    fi
fi

project=$1
webdir=02www
mkdir -p $webdir
if [ ! -d $webdir ]; then
    echo esp-live.sh: $webdir does not exist and cannot be created
    exit 1
fi

if [ "$force" != "yes" ]; then
    echo "Make development directory live -- are you sure?"
    echo "(type 'yes' or 'no' then press [Enter])"
    read CONFIRM
    if ! test $CONFIRM = yes
    then exit 1
    fi
fi

esp=01tmp/dev/
log=02www/last_esp2_cp.log
rm -f 02www/_test
cp -Rv $esp 02www | cut -d'>' -f2 | grep / | sed 's/ //' >$log
chmod -R o+r $webdir/
chmod o-r $log
echo esp now live at oracc/$project.

exit 0
