# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/daaplib/daaplib-0.1.1a.ebuild,v 1.5 2004/06/24 22:57:20 agriffis Exp $

inherit eutils

DESCRIPTION="a tiny, portable C++ library to read and write low-level DAAP streams in memory"
HOMEPAGE="http://www.deleet.de/projekte/daap/daaplib/"
SRC_URI="http://deleet.de/projekte/daap/daaplib/${PN}.${PV}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="static"
DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}.${PV}/daaplib/src

src_unpack() {
	unpack ${A}

	# Use updated gentoo Makefile
	ebegin "Updating Makefile"
	cp ${FILESDIR}/${P}-Makefile ${S}/makefile
	eend $?
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR="${D}" PREFIX=/usr install
	use static || rm ${D}/usr/lib/libdaaplib.a

	dodoc ../../COPYING ../../README
}
