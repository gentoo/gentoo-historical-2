# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/chktex/chktex-1.5-r2.ebuild,v 1.13 2003/03/10 22:49:24 agriffis Exp $

SRC_URI="http://www.ibiblio.org/pub/linux/distributions/gentoo/${P}.tar.gz"
HOMEPAGE="http://www.nongnu.org/chktex/"
DESCRIPTION="Checks latex source for common mistakes"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="app-text/tetex
	sys-devel/perl
	sys-apps/groff
	app-text/latex2html"

src_compile() {
	[ -n "$DEBUG" ] && myconf="--enable-debug-info" || myconf="$myconf --disable-debug-info"
	econf ${myconf}
	emake || die
}

src_install() {
	einstall
	dodoc COPYING SCOPTIONS
}
