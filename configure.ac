dnl $Id: configure.in,v 1.1 1998/11/05 03:26:43 s Exp s $
AC_INIT(Oracc,1.0)
AC_LANG(C)
AC_CONFIG_SRCDIR(c/include/psd_base.h)
AM_INIT_AUTOMAKE
LT_INIT
AC_CONFIG_HEADERS(config.h)
AM_CONDITIONAL(AMDEP,true)

dnl Checks for programs.
AC_CONFIG_MACRO_DIR([m4])
AC_PROG_CC
AC_PROG_CXX
AC_PROG_YACC
AM_PROG_LEX
AC_PROG_LIBTOOL
AC_PROG_INSTALL
AC_PROG_LN_S
dnl AC_PROG_RANLIB
AC_PROG_MAKE_SET
AC_PATH_PROG(PERL,perl)

dnl Checks for libraries.
dnl Replace `main' with a function in -lfl:

AC_SEARCH_LIBS(pcre,pcre_exec)

dnl AC_SEARCH_LIBS(iconv,iconv,,
dnl     AC_SEARCH_LIBS(libiconv,iconv,,AC_MSG_ERROR(['libiconv' is required but it doesn't seem to be installed on this system.]),))

dnl Checks for header files.
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS(fcntl.h limits.h malloc.h strings.h unistd.h)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_MODE_T
AC_TYPE_OFF_T
AC_TYPE_SIZE_T
AC_STRUCT_TM

dnl AC_SEARCH_LIBS(iconv,iconv)
dnl echo ac_cv_search = +$ac_cv_search+
dnl if test "$ac_cv_search" == ""
dnl then
dnl   LIBICONV=
dnl else
dnl   LIBICONV=-liconv
dnl fi
dnl echo LIBICONV=$LIBICONV

dnl # Checking the version of QDBM with pkg-config
dnl if type pkg-config > /dev/null 2>&1
dnl then
dnl  printf 'checking the version of QDBM ... '
dnl  if pkg-config --atleast-version=1.8.75 qdbm
dnl  then
dnl    printf 'ok (%s)\n' `pkg-config --modversion qdbm`
dnl    QDBMINCLUDE="-I`pkg-config --variable=includedir qdbm`"
dnl    QDBMLIBDIR="-L`pkg-config --variable=libdir qdbm`"
dnl  else
dnl    printf 'no (maybe not installed or too old)\n'
dnl  fi
dnl else
dnl    QDBMINCLUDE=
dnl    QDBMLIBDIR=
dnl fi

dnl Checks for library functions.
AC_FUNC_SETVBUF_REVERSED
AC_FUNC_VPRINTF
AC_CHECK_FUNCS(mkdir strerror)

XMLRPC_CLIENT_LIBS="`xmlrpc-c-config client --libs`"
XMLRPC_CGISERVER_LIBS="`xmlrpc-c-config cgi-server --libs`"
AC_SUBST(XMLRPC_CLIENT_LIBS)
AC_SUBST(XMLRPC_CGISERVER_LIBS)

AC_SUBST(LIBICONV)
dnl AC_SUBST(QDBMINCLUDE)
dnl AC_SUBST(QDBMLIBDIR)

dnl 	   oracc-hyperestraier/estconfig

AC_OUTPUT([Makefile 
	   oracc-hyperestraier/Makefile
	   oracc-hyperestraier/qdbm/Makefile
	   c/Makefile
	   c/bin/Makefile
	   c/bin/lemmer/Makefile
	   c/bin/matrix/Makefile
	   c/bin/oraccnet/Makefile
	   c/bin/oraccnet/client/Makefile
	   c/bin/oraccnet/lib/Makefile
	   c/bin/oraccnet/server/Makefile
	   c/bin/oraccnet/server/ccgi/Makefile
	   c/bin/oraccnet/xmlrpc/Makefile
	   c/bin/pg/Makefile
	   c/bin/rnv/Makefile
	   c/bin/se/Makefile
	   c/bin/se/secatx/Makefile
	   c/bin/se/secbdx/Makefile
	   c/bin/se/selemx/Makefile
	   c/bin/se/setxtx/Makefile
	   c/bin/se/setrax/Makefile
	   c/bin/sort/Makefile 
	   c/bin/util/Makefile
	   c/include/Makefile
	   c/lib/Makefile
	   c/lib/collate/Makefile 
	   c/lib/collate/mktablst 
	   c/lib/collate/seq2c
	   c/lib/expat/Makefile
	   c/lib/gsl/Makefile
	   c/lib/libstemmer_c/Makefile
	   c/lib/oracc/Makefile
	   c/lib/rnv/Makefile
	   c/lib/sas/Makefile
	   c/lib/skl/Makefile
	   c/otf/Makefile
	   c/otf/atf/Makefile
	   c/otf/chr/Makefile
	   c/otf/gdl/Makefile
	   c/otf/lib/Makefile
	   c/otf/lib/mk_rnc.sh
	   c/otf/lng/Makefile
	   c/otf/otf/Makefile
	   c/otf/ox/Makefile
	   c/otf/prj/Makefile
	   c/otf/run/Makefile
	   c/l2/Makefile
	   c/l2/bigrams/Makefile
	   c/l2/dsa/Makefile
	   c/l2/form/Makefile
	   c/l2/ilem/Makefile
	   c/l2/link/Makefile
	   c/l2/ngram/Makefile
	   c/l2/nsa/Makefile
	   c/l2/prop/Makefile
	   c/l2/psa/Makefile
	   c/l2/psus/Makefile
	   c/l2/sigs/Makefile
	   c/l2/word/Makefile
	   c/l2/xcl2/Makefile
	   c/l2/xli/Makefile
	   misc/Makefile
	   misc/admin/Makefile
	   misc/agg/Makefile
	misc/atf/Makefile
	misc/bib/Makefile
	misc/catf/Makefile
	misc/ce/Makefile
	misc/chi/Makefile
	misc/cs/Makefile
	misc/emacs/Makefile
	misc/epsd/Makefile
	misc/epsd2/Makefile
	misc/esp/Makefile
	misc/esp2/Makefile
	misc/est/Makefile
	misc/fonts/Makefile
	misc/fxr/Makefile
	misc/g2plus/Makefile
	misc/gdf/Makefile
	misc/gdl/Makefile
	misc/issl/Makefile
	misc/l2common/Makefile
	misc/l2phase1/Makefile
	misc/l2phase2/Makefile
	misc/l2phase3/Makefile
	misc/legacy/Makefile
	misc/lib/Makefile
	misc/log/Makefile
	misc/msort/Makefile
	misc/msv/Makefile
	misc/nsa/Makefile
	misc/o2/Makefile
	misc/ods/Makefile
	misc/ogsl/Makefile
	misc/ol/Makefile
	misc/oss2/Makefile
	misc/otf/Makefile
	misc/p3/Makefile
	misc/print/Makefile
	misc/ptb/Makefile
	misc/saxon/Makefile
	misc/schemas/Makefile
	misc/se/Makefile
	misc/sl/Makefile
	misc/sma/Makefile
	misc/ssa3/Makefile
	misc/system/Makefile
	misc/tei/Makefile
	misc/tex/Makefile
	misc/texts/Makefile
	misc/urn/Makefile
	misc/util/Makefile
	misc/version/Makefile
	misc/web/Makefile
	misc/www/Makefile
	misc/xcf/Makefile
	misc/xcl/Makefile
	misc/xdf/Makefile
	misc/xix/Makefile
	misc/xmd/Makefile
	misc/xpd2/Makefile
	misc/xse/Makefile
	misc/xst/Makefile
	misc/xtf/Makefile
	misc/xtl/Makefile
	misc/xtr/Makefile
	misc/xvl/Makefile
	doc/Makefile
	doc/00tools/Makefile
	doc/builder/Makefile
	doc/developer/Makefile
	doc/install/Makefile
	doc/manager/Makefile
	doc/ns/Makefile
	doc/ood/Makefile
	doc/sysadmin/Makefile
	doc/urn/Makefile
	doc/user/Makefile
	doc/wwwhome/Makefile
	doc/ood/resources/Makefile
	doc/ood/urns/Makefile
	doc/ood/uris/Makefile
	doc/ood/uri-text/Makefile
	doc/ood/uri-examples/Makefile
	doc/ood/uri-patterns/Makefile
	doc/ood/gdf/Makefile
	doc/builder/linganno/ARC/Makefile
	doc/builder/linganno/UGA/Makefile
	doc/builder/linganno/PEO/Makefile
	doc/builder/linganno/Makefile
	doc/builder/linganno/GRC/Makefile
	doc/builder/linganno/ELX/Makefile
	doc/builder/linganno/QPN/Makefile
	doc/builder/linganno/SUX/Makefile
	doc/builder/linganno/SUX/primer/Makefile
	doc/builder/linganno/SUX/syntax/Makefile
	doc/builder/linganno/AKK/akkstyle/Makefile
	doc/builder/linganno/AKK/akk-roots/Makefile
	doc/builder/linganno/AKK/akk-ob/Makefile
	doc/builder/linganno/AKK/Makefile
	doc/builder/l2/Makefile
	doc/builder/l2/PSUs/Makefile
	doc/builder/l2/BFFs/Makefile
	doc/builder/l2/F2/Makefile
	doc/builder/l2/howtouseit/Makefile
	doc/builder/l2/glossaries/Makefile
	doc/builder/l2/lem/Makefile
	doc/builder/l2/COFs/Makefile
	doc/builder/l2/lemsyntax/Makefile
	doc/builder/l2/howitworks/Makefile
	doc/builder/dates/Makefile
	doc/builder/labels/Makefile
	doc/builder/primer/Makefile
	doc/builder/metrology/Makefile
	doc/builder/layouts/Makefile
	doc/builder/quickref/Makefile
	doc/builder/numbers/Makefile
	doc/builder/translation/Makefile
	doc/builder/cdli/Makefile
	doc/builder/bilinguals/Makefile
	doc/builder/math/Makefile
	doc/builder/scores/Makefile
	doc/builder/emacs/Makefile
	doc/builder/emacs/emacsw32/Makefile
	doc/builder/emacs/aquamacs/Makefile
	doc/install/prereqs/Makefile
	doc/install/neworacc/Makefile
	doc/install/basics/Makefile
	doc/install/ports/Makefile
	doc/developer/xdftut/Makefile
	doc/developer/psa/Makefile
	doc/developer/versions/Makefile
	doc/developer/l2/Makefile
	doc/developer/l2/langtags/Makefile
	doc/developer/l2/howtouseit/Makefile
	doc/developer/l2/lemsyntax/Makefile
	doc/developer/l2/howitworks/Makefile
	doc/developer/exist/example1/Makefile
	doc/developer/exist/projects/Makefile
	doc/developer/exist/example3/Makefile
	doc/developer/exist/example4/Makefile
	doc/developer/exist/install/Makefile
	doc/developer/exist/example2/Makefile
	doc/developer/exist/example6/Makefile
	doc/developer/exist/example7/Makefile
	doc/developer/exist/example8/Makefile
	doc/developer/exist/example5/Makefile
	doc/developer/exist/starting/Makefile
	doc/developer/exist/Makefile
	doc/developer/tei/Makefile
	doc/developer/nsa/Makefile
	doc/developer/xmlarch/Makefile
	doc/developer/projweb/Makefile
	doc/developer/fxr/1.0/Makefile
	doc/developer/opendocument/Makefile
	doc/developer/cuneify/Makefile
	doc/developer/uri/Makefile
	doc/manager/projects/Makefile
	doc/manager/portals/espimages/Makefile
	doc/manager/portals/espbuild/Makefile
	doc/manager/portals/esp/Makefile
	doc/manager/portals/esperrors/Makefile
	doc/manager/portals/espelements/Makefile
	doc/manager/portals/espcontent/Makefile
	doc/manager/portals/projurls/Makefile
	doc/manager/portals/Makefile
	doc/manager/portals/espsetup/Makefile
	doc/manager/the-oracc-command/Makefile
	doc/manager/projemacs/Makefile
	doc/manager/projunix/Makefile
	doc/manager/projlife/Makefile
	doc/manager/projcats/Makefile
	doc/manager/filesystem/Makefile
	doc/manager/proxies/Makefile
	doc/manager/webcolours/Makefile
	doc/manager/projconfig/c2/ol/Makefile
	doc/manager/projconfig/c2/colours/Makefile
	doc/manager/projconfig/c2/views/Makefile
	doc/manager/projconfig/c2/pll/Makefile
	doc/manager/projconfig/c2/Makefile
	doc/manager/projconfig/Makefile
	doc/ns/xcl/1.0/Makefile
	doc/ns/xmd/1.0/Makefile
	doc/ns/cbd/2.0/Makefile
	doc/ns/cbd/1.0/Makefile
	doc/ns/xcf/1.0/Makefile
	doc/ns/xtc/1.0/Makefile
	doc/ns/xpd/1.0/Makefile
	doc/ns/cdf/1.0/Makefile
	doc/ns/gdl/1.0/Makefile
	doc/ns/sl/1.0/Makefile
	doc/ns/esp/1.0/Makefile
	doc/ns/xst/1.0/Makefile
	doc/ns/xtr/1.0/Makefile
	doc/ns/xdf/1.0/Makefile
	doc/ns/xtf/1.0/Makefile
	doc/ns/xse/1.0/Makefile
	doc/user/userguide/Makefile
	doc/user/citing/Makefile
	doc/user/searching/Makefile
	doc/user/fonts/Makefile
	doc/user/p2/Makefile
	doc/user/unicode/Makefile
	doc/user/glossaries/Makefile
	doc/user/keyboards/Makefile
	doc/user/fulltextsearch/Makefile
	doc/user/advanced/Makefile
])
