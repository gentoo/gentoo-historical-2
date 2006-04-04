# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/zile/zile-2.2.13.ebuild,v 1.2 2006/04/04 18:10:22 exg Exp $

inherit eutils

DESCRIPTION="Zile is a small Emacs clone"
HOMEPAGE="http://zile.sourceforge.net/"
SRC_URI="mirror://sourceforge/zile/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~ppc ~amd64"
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
	dodoc FAQ dotzile.sample TUTORIAL NEWS README THANKS AUTHORS INSTALL COPYING
}
