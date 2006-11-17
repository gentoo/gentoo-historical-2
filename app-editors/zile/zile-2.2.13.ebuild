# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/zile/zile-2.2.13.ebuild,v 1.11 2006/11/17 23:02:00 flameeyes Exp $

inherit eutils

DESCRIPTION="Zile is a small Emacs clone"
HOMEPAGE="http://zile.sourceforge.net/"
SRC_URI="mirror://sourceforge/zile/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/ncurses
	>=sys-apps/texinfo-4.3"
PROVIDE="virtual/editor"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS NEWS README THANKS
}
