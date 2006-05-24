# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cbrpager/cbrpager-0.9.11.ebuild,v 1.4 2006/05/24 00:19:03 vapier Exp $

DESCRIPTION="a simple comic book pager for Linux"
HOMEPAGE="http://cbrpager.sourceforge.net"
SRC_URI="mirror://sourceforge/cbrpager/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="|| ( app-arch/unrar app-arch/unrar-gpl )
	>=x11-libs/gtk+-2.0.6
	>=gnome-base/libgnomeui-2.8.0
	>=gnome-base/libgnomecanvas-2.8.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
