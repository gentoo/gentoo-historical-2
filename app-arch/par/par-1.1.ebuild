# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/par/par-1.1.ebuild,v 1.12 2003/02/13 05:55:48 vapier Exp $

S=${WORKDIR}/par-cmdline
DESCRIPTION="Parchive archive fixing tool"
SRC_URI="mirror://sourceforge/parchive/par-v${PV}.tar.gz"
HOMEPAGE="http://parchive.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="virtual/glibc"

src_unpack() {
	unpack par-v${PV}.tar.gz
	cd ${S}
	source /etc/make.conf
	mv Makefile Makefile.orig
	sed "s/CFLAGS.*/CFLAGS = -Wall $CFLAGS/" Makefile.orig > Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin par
	dodoc COPYING AUTHORS NEWS README rs.doc
}
