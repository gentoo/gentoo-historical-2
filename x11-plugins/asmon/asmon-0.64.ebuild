# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/asmon/asmon-0.64.ebuild,v 1.1 2004/06/13 04:13:11 pyrania Exp $

inherit eutils

DESCRIPTION="WindowMaker/AfterStep system monitor dockapp"
HOMEPAGE="http://rio.vg/asmon/"
SRC_URI="http://www.tigr.net/afterstep/download/asmon/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~sparc ~ppc"
DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/asmon-cflags.diff
}

src_compile() {
	cd ${S}/asmon
	make clean
	emake || die
}

src_install() {
	dodoc AUTHOR CHANGES COPYING INSTALL INSTALL.orig
	cd asmon
	dobin ${PN}
}
