# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fbset/fbset-2.1.ebuild,v 1.30 2005/12/29 10:24:15 vapier Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A utility to set the framebuffer videomode"
HOMEPAGE="http://members.chello.be/cr26864/Linux/fbdev/"
SRC_URI="http://home.tvd.be/cr26864/Linux/fbdev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "/^CC =/s:gcc:$(tc-getCC):" \
		-e "/^CC =/s:-O2:${CFLAGS}:" \
		-e 's/^modes.tab.c/modes.tab.h modes.tab.c/' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	replace-flags -O3 -O2
	emake || die "emake failed"
}

src_install() {
	dobin fbset modeline2fb || die "dobin failed"
	doman *.[58]
	dodoc etc/fb.modes.* INSTALL
}
