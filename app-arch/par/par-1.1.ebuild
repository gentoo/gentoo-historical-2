# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/par/par-1.1.ebuild,v 1.19 2004/06/25 23:52:56 vapier Exp $

DESCRIPTION="Parchive archive fixing tool"
HOMEPAGE="http://parchive.sourceforge.net/"
SRC_URI="mirror://sourceforge/parchive/par-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE=""

DEPEND="virtual/libc
	>=sys-apps/sed-4"

S=${WORKDIR}/par-cmdline

src_unpack() {
	unpack par-v${PV}.tar.gz
	cd ${S}
	sed -i "s/CFLAGS.*/CFLAGS = -Wall ${CFLAGS}/" Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin par || die
	dodoc AUTHORS NEWS README rs.doc
}
