# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SGMLSpm/SGMLSpm-1.03-r5.ebuild,v 1.9 2004/07/26 23:24:36 agriffis Exp $

MY_P="${P}ii"
S=${WORKDIR}/${PN}
DESCRIPTION="Perl library for parsing the output of nsgmls"
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DM/DMEGG/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/DMEGG/SGMLSpm-1.03ii/"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~sparc alpha ~ppc ~hppa ia64 mips ppc64"
DEPEND=">=dev-lang/perl-5.8.0-r12
		>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/${P}-Makefile ${S}/Makefile
	eval `perl '-V:package'`
	eval `perl '-V:version'`
	cd ${S}
	sed -i -e "s:5.6.1:${version}:" Makefile
#	sed -i -e "s:perl5:perl5/vendor_perl/${version}:" Makefile
	sed -i -e "s:MODULEDIR = \${PERL5DIR}/site_perl/${version}/SGMLS:MODULEDIR = \${PERL5DIR}/vendor_perl/${version}/SGMLS:" Makefile
	sed -i -e "s:SPECDIR = \${PERL5DIR}:SPECDIR = ${D}/usr/share/SGMLS:" Makefile
	sed -i -e "s:\${PERL5DIR}/SGMLS.pm:\${PERL5DIR}/vendor_perl/${version}/SGMLS.pm:" Makefile
	sed -i -e "s/^all: .*/all:/" Makefile
}

src_install () {
	dodir /usr/bin
	dodir /usr/lib/${package}/vendor_perl/${version}
	dodir /usr/share/SGMLS
	dodoc BUGS COPYING ChangeLog README TODO
	make install -f ${S}/Makefile || die
	make docs -f ${S}/Makefile || die
#	cd ${D}/usr/lib/${package}/vendor_perl/${version}
}
