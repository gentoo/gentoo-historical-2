# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SGMLSpm/SGMLSpm-1.03-r4.ebuild,v 1.2 2002/11/03 04:32:55 nall Exp $

MY_P="${P}ii"
S=${WORKDIR}/${PN}
DESCRIPTION="Perl library for parsing the output of nsgmls"
SRC_URI="http://cpan.perl.org/pub/perl/CPAN/modules/by-module/SGMLS/${MY_P}.tar.gz"
HOMEPAGE="http://cpan.perl.org/pub/perl/CPAN/modules/by-module/SGMLS/${MY_P}.readme"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64 alpha ppc"

src_unpack() {

	unpack ${A}
	cp ${FILESDIR}/${P}-Makefile ${S}/Makefile

}

src_install () {
	
	eval `perl '-V:package'`
	eval `perl '-V:version'`
	cd ${S}
	dodir /usr/lib/${package}/site_perl/${version}
	dodir /usr/bin
	cp Makefile Makefile.bak
	sed -e "s:5.6.1:${version}:" Makefile.bak > Makefile
	cp Makefile Makefile.bak
	sed -e "s:perl5:perl5/site_perl/${version}:" Makefile.bak > Makefile
	cp Makefile Makefile.bak
	sed -e "s:MODULEDIR = \${PERL5DIR}/site_perl/${version}/SGMLS:MODULEDIR = \${PERL5DIR}/SGMLS:" Makefile.bak > Makefile
	make -f Makefile || die
	cd ${D}/usr/lib/${package}/site_perl/${version}
	#mv SGMLS.pm site_perl/${version}/SGMLS.pm

	dodoc BUGS COPYING ChangeLog README TODO

}
