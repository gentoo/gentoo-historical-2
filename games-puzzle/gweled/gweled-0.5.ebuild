# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gweled/gweled-0.5.ebuild,v 1.2 2004/09/04 23:01:36 dholm Exp $

inherit flag-o-matic

DESCRIPTION="Bejeweled clone game"
HOMEPAGE="http://sebdelestaing.free.fr/gweled/"
SRC_URI="http://sebdelestaing.free.fr/gweled/Release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

DEPEND=">=x11-libs/gtk+-2
	>=gnome-base/librsvg-2
	>=gnome-base/libgnomeui-2"

src_compile() {
	filter-flags -fomit-frame-pointer
	econf || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS
}
