# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xstroke/xstroke-0.5.12.ebuild,v 1.6 2002/12/09 04:41:55 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Gesture/Handwriting recognition engine for X"
SRC_URI="ftp://ftp.handhelds.org/pub/projects/xstroke/release-0.5/${P}.tar.gz"
HOMEPAGE="http://www.east.isi.edu/projects/DSN/xstroke/"
LICENSE="GPL-2"
DEPEND=">=x11-base/xfree-4.1.0"
SLOT="0"
KEYWORDS="x86 sparc "

src_unpack() {

	cd ${WORKDIR}
	unpack ${P}.tar.gz
	patch -p0 < ${FILESDIR}/${PN}-${PV}-gentoo.diff || die

}

src_compile() {

	make DESTDIR=${D} || die

}

src_install() {

	make DESTDIR=${D} BINDIR=/usr/bin install || die

}

