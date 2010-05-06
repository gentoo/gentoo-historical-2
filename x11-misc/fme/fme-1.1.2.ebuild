# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fme/fme-1.1.2.ebuild,v 1.2 2010/05/06 11:18:59 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="Graphical menu editor for Fluxbox menus"
HOMEPAGE="http://fme.rhymux.info/"
SRC_URI="http://fme.rhymux.info/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-devel/bc
	>=x11-wm/fluxbox-1.0
	>=dev-cpp/gtkmm-2.4
	>=dev-cpp/glibmm-2.14.0
	>=dev-cpp/libglademm-2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc45.patch
}

src_install() {
	emake DESTDIR="${D}" install || die

	doicon glade/${PN}.png
	make_desktop_entry ${PN} "Fluxbox Menu Editor" ${PN} "Settings;DesktopSettings"

	dodoc AUTHORS ChangeLog README TODO
}
