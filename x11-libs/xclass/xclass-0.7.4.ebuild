# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xclass/xclass-0.7.4.ebuild,v 1.1 2002/10/23 14:45:25 vapier Exp $

IUSE=""
DESCRIPTION="a C++ GUI toolkit for the X windows environment"
HOMEPAGE="http://xclass.sourceforge.net/"
SRC_URI="ftp://mitac11.uia.ac.be/pub/xclass/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"

DEPEND="virtual/x11
	virtual/glibc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_compile() {
	econf --enable-shared=yes --with-x || die "configure failed"

	# for some reason -fPIC dies while sandboxed ...
	cd ${S}/lib/libxclass
	cp Makefile Makefile.old
	sed -e "s/shared: CXXFLAGS += -fPIC//" \
		Makefile.old > Makefile

	cd ${S}
	if [ "`use static`" ] ; then
		emake		|| die "'emake' failed"
	else
		emake shared	|| die "'emake shared' failed"
	fi
}

src_install() {
	cd ${S}
	rm -rf `find . -name 'Makefile*'`

	dobin config/xc-config

	dodoc doc/*

	dodir /usr/share/xclass
	insinto /usr/share/xclass
	mv "icons/Lock screen.s.xpm" ${D}/usr/share/xclass/
	doins icons/*.xpm

	dodir /usr/include/xclass
	insinto /usr/include/xclass
	doins include/xclass/*.h

	dolib lib/libxclass/lib*
}
