# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/sux/sux-1.0-r1.ebuild,v 1.5 2004/07/03 12:04:20 slarti Exp $

inherit eutils

DESCRIPTION="\"su\" wrapper which transfers X credentials"
HOMEPAGE="http://fgouget.free.fr/sux/sux-readme.shtml"
SRC_URI="http://fgouget.free.fr/sux/sux"
LICENSE="X11"
SLOT="0"

KEYWORDS="x86 ~amd64"
IUSE=""
S=${WORKDIR}

DEPEND="virtual/x11
		sys-apps/debianutils"

src_unpack() {
	cp ${DISTDIR}/${A} .
	epatch ${FILESDIR}/${P}-r1.patch
}

src_compile() {
	echo "nothing to be done"
}

src_install() {
	exeinto /usr/X11R6/bin
	doexe sux
}
