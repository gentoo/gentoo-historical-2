# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pipes/pipes-1.15.ebuild,v 1.2 2003/11/03 20:02:22 mr_bones_ Exp $

DESCRIPTION="Very versatile TCP pipes"
HOMEPAGE="http://bisqwit.iki.fi/source/pipes.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="virtual/glibc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:-O2:${CFLAGS}:" Makefile || \
			die "sed Makefile failed"
	touch .depend
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin plis                         || die "dobin failed"
	dohard /usr/bin/plis /usr/bin/pcon || die "dohard failed"
	dodoc Examples ChangeLog           || die "dodoc failed"
	dohtml README.html                 || die "dohtml failed"
}
