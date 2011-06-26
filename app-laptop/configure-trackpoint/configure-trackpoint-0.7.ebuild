# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/configure-trackpoint/configure-trackpoint-0.7.ebuild,v 1.1 2011/06/26 12:21:20 hwoarang Exp $

EAPI=2
inherit gnome2

DESCRIPTION="Thinkpad GNOME configuration utility for tp_smapi"
HOMEPAGE="http://tpctl.sourceforge.net/configure-thinkpad.html"
SRC_URI="mirror://sourceforge/tpctl/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-laptop/tp_smapi
	>=x11-libs/gtk+-2.2:2
	|| ( x11-libs/gksu kde-base/kdesu )
	>=gnome-base/libgnomeui-2.4
	>=sys-devel/gettext-0.11"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	if has_version kde-base/kdesu && ! has_version x11-libs/gksu; then
		sed -i -e "/^Exec/s:gksu:kdesu:" ${PN}.desktop \
			|| die "Failed to replace gksu with kdesu"
	fi
	gnome2_src_prepare
}

src_configure() {
	G2CONF="--disable-dependency-tracking --disable-maintainer-mode"
	gnome2_src_configure
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog
	elog "The ${PN} does not automatically load the app-laptop/tp_smapi modules"
	elog "so you need to do it manually"
	elog
}
