include ../../oracc-am-rules.txt

bin_SCRIPTS = sametlit.plx sl-cuneify.plx sl-db.plx sl-install.sh sl-pdf.sh \
	sl-se.plx sl-xml.plx slmanager.plx slsig.plx
cgibin_SCRIPTS=slse
texdata_DATA = gslmac.tex
scriptdata_DATA = gsl-TeX.xsl sl-HTML.xsl

slse: slse.in
	$(ORACCIFY) slse.in

slsig.plx: slsig.plx.in
	$(ORACCIFY) slsig.plx.in

sametlit.plx: sametlit.plx.in
	$(ORACCIFY) sametlit.plx.in

EXTRA_DIST = \
	Base.pm \
	gsl-TeX.xsl \
	gslmac.tex \
	nsl-db.plx \
	sametlit.plx.in \
	sl-HTML.xsl \
	sl-cuneify.plx \
	sl-db.plx \
	sl-install.sh \
	sl-pdf.sh \
	sl-se.plx \
	sl-xml.plx \
	slmanager.plx
