# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/indicator-messages/indicator-messages-0.5.0-r200.ebuild,v 1.1 2011/11/19 17:24:19 ssuominen Exp $

EAPI=4
inherit gnome2-utils

DESCRIPTION="A place on the user's desktop that collects messages that need a response"
HOMEPAGE="http://launchpad.net/indicator-messages"
SRC_URI="http://launchpad.net/indicator-messages/0.5/0.5.0/+download/indicator-messages-0.5.0.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libdbusmenu-0.3.94[gtk,-gtk3]
	>=dev-libs/glib-2.18:2
	>=dev-libs/libindicate-0.4.90
	>=dev-libs/libindicator-0.3.19
	net-libs/telepathy-glib
	>=x11-libs/gtk+-2.12:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

DOCS=( AUTHORS ChangeLog )

src_configure() {
	econf --with-gtk=2
}

src_install() {
	default
	find "${ED}"usr -name '*.la' -exec rm -f {} +
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
