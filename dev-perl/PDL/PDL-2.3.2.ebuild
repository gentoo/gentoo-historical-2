# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PDL/PDL-2.3.2.ebuild,v 1.1 2002/01/28 18:25:50 gbevin Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PDL Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/PDL/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/PDL/${P}.readme"

DEPEND=">=sys-devel/perl-5
	>=sys-libs/ncurses-5.2
	>=dev-perl/ExtUtils-F77-1.13"
#	opengl? ( virtual/opengl virtual/glu )

src_unpack() {
	unpack ${A}

	#open gl does not work at the moment
	if [ "`use opengl`" ]
	then
		echo "OpenGL support is current disabled due to build issues"
		sed -e "s:WITH_3D => undef:WITH_3D => 0:" ${FILESDIR}/perldl.conf > ${S}/perldl.conf
	else
		sed -e "s:WITH_3D => undef:WITH_3D => 0:" ${FILESDIR}/perldl.conf > ${S}/perldl.conf
	fi
}

src_compile() {
	perl Makefile.PL

	make || die
	make test || die
}

src_install () {
	make PREFIX=${D}/usr 						\
	     INSTALLMAN1DIR=${D}/usr/share/man/man1			\
	     INSTALLMAN3DIR=${D}/usr/share/man/man3 			\
	     install || die

	dodoc COPYING Changes DEPENDENCIES DEVELOPMENT README MANIFEST*

	dodoc Release_Notes TODO
	mv ${D}/usr/lib/perl5/site_perl/5.6.0/${CHOST%%-*}-linux/PDL/HtmlDocs ${D}/usr/doc/${P}/html
	mydir=${D}/usr/doc/${P}/html/PDL

	for i in ${mydir}/* ${mydir}/IO/* ${mydir}/Fit/* ${mydir}/Pod/* ${mydir}/Graphics/* 
	do
		dosed ${i/${D}}
	done

	dosed /usr/lib/perl5/site_perl/5.6.0/${CHOST%%-*}-linux/PDL/pdldoc.db 
}






