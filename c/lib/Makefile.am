## Process this file with automake to produce Makefile.in
##
#  Copyright(c) Pennsylvania Sumerian Dictionary and Steve Tinney
#  1997 under the GNU General Public License (see /psd/COPYING).
# 
#  $Id: Makefile.am,v 0.5 1997/09/08 13:02:15 sjt Exp $

AM_CFLAGS=-ansi -pedantic -Wall -g
SUBDIRS=collate expat libstemmer_c gsl oracc rnv sas skl
noinst_LTLIBRARIES=liboracc.la
liboracc_la_LIBADD= \
	collate/libcoll.la \
	oracc/liboracc.la \
	expat/libexpat.la \
	gsl/libgsl.la \
	libstemmer_c/libstemmer.la \
	rnv/librnv.la \
	sas/libsas.la \
	skl/libskl.la
