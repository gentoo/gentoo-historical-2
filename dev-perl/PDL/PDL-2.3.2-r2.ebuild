# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PDL/PDL-2.3.2-r2.ebuild,v 1.6 2003/09/06 22:37:58 msterret Exp $

IUSE="opengl"

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="PDL Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/PDL/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/PDL/${P}.readme"

SLOT="0"
LICENSE="Artistic as-is"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	>=sys-libs/ncurses-5.2
	>=dev-perl/ExtUtils-F77-1.13
	opengl? ( virtual/opengl virtual/glu )"

mydoc="DEPNDENCIES DEVELOPMENT MANIFEST* COPYING Release_Notes TODO"

src_unpack() {

	unpack ${A}

	#open gl does not work at the moment
	if [ "`use opengl`" ]
	then
		echo "OpenGL support is current disabled due to build issues"
		sed -e "s:WITH_3D => undef:WITH_3D => 0:" \
			${FILESDIR}/perldl.conf > ${S}/perldl.conf
	else
		sed -e "s:WITH_3D => undef:WITH_3D => 0:" \
			${FILESDIR}/perldl.conf > ${S}/perldl.conf
	fi
}

src_install () {

	perl-module_src_install

	mv ${D}/usr/lib/perl5/site_perl/5.6.0/${CHOST%%-*}-linux/PDL/HtmlDocs \
		${D}/usr/doc/${P}/html

	mydir=${D}/usr/doc/${P}/html/PDL

	for i in ${mydir}/* ${mydir}/IO/* ${mydir}/Fit/* ${mydir}/Pod/* ${mydir}/Graphics/*
	do
		dosed ${i/${D}}
	done

	dosed /usr/lib/perl5/site_perl/5.6.0/${CHOST%%-*}-linux/PDL/pdldoc.db
}
