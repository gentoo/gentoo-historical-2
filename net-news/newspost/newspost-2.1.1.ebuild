# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/newspost/newspost-2.1.1.ebuild,v 1.7 2004/06/25 00:26:00 agriffis Exp $

DESCRIPTION="a usenet binary autoposter for unix"
HOMEPAGE="http://newspost.unixcab.org/"
SRC_URI="http://newspost.unixcab.org/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

# NOTE: This package should work on PPC but not tested!
# It also has a solaris make file but we don't do solaris.
# but it should mean that it is 64bit clean.
KEYWORDS="x86 ~amd64"

RDEPEND="virtual/glibc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:OPT_FLAGS = :OPT_FLAGS = ${CFLAGS}#:" Makefile || \
			die "sed Makefile failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install () {
	dobin newspost
	doman man/man1/newspost.1
	dodoc README CHANGES COPYING
}
