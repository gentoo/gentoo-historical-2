# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/menu-cache/menu-cache-0.3.2.ebuild,v 1.3 2010/07/30 08:25:00 fauli Exp $

EAPI="2"

DESCRIPTION="A library creating and utilizing caches to speed up freedesktop.org application menus"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README || die "dodoc failed"
}
