#!/bin/sh
cd ~
. .profile
sudo port install autoconf
sudo port install autoheader
sudo port install automake
sudo port install libtool
sudo port install gdbm
sudo port install pcre
sudo port install msort