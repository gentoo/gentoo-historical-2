# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xfractint/xfractint-20.2.05.ebuild,v 1.11 2004/04/27 18:24:37 agriffis Exp $

inherit eutils flag-o-matic

MY_P=xfract${PV}

S="${WORKDIR}/xfractint-20.02p05"
DESCRIPTION="The best fractal generator for X."
HOMEPAGE="http://www.fractint.org/"
SRC_URI="http://www.fractint.org/ftp/old/linux/${MY_P}.tar.gz"

KEYWORDS="x86 sparc"
SLOT="0"
LICENSE="freedist"
IUSE=""

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	virtual/x11"

RDEPEND=$DEPEND

src_unpack() {
	unpack ${MY_P}.tar.gz
	epatch ${FILESDIR}/xfractint-20.02p05.patch
}

src_compile() {
	cd ${S}
	cp Makefile Makefile.orig
	replace-flags "-funroll-all-loops" "-funroll-loops"
	sed -e "s:CFLAGS = :CFLAGS = $CFLAGS :" Makefile.orig >Makefile

	MAKEOPTS='-j1' emake
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/xfractint
	dodir /usr/man/man1

	make \
		BINDIR=${D}usr/bin \
		MANDIR=${D}usr/man/man1 \
		SRCDIR=${D}usr/share/xfractint \
		install || die

	insinto /etc/env.d
	newins ${FILESDIR}/xfractint.envd 60xfractint
}

pkg_postinst() {
	einfo
	einfo "XFractInt requires the FRACTDIR variable to be set in order to start."
	einfo "Please re-login or \`source /etc/profile\` to have this variable set automatically."
	einfo
}
