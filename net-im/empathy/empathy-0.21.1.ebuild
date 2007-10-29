# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/empathy/empathy-0.21.1.ebuild,v 1.1 2007/10/29 00:54:20 coldwind Exp $

inherit gnome2 eutils versionator

MAJOR_V="$(get_version_component_range 1-2)"

DESCRIPTION="Empathy Telepathy client"
HOMEPAGE="http://live.gnome.org/Empathy"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/${MAJOR_V}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python spell"

RDEPEND=">=dev-libs/dbus-glib-0.51
	>=dev-libs/glib-2.14.0
	dev-libs/libxml2
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=net-libs/libtelepathy-0.0.57
	>=net-im/telepathy-mission-control-4.37
	>=x11-libs/gtk+-2.12.0
	>=gnome-base/gnome-vfs-2
	>=gnome-extra/evolution-data-server-1.2
	gnome-base/gnome-panel
	spell? ( app-text/aspell )
	python? ( >=dev-lang/python-2.4.4-r5 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="CONTRIBUTORS AUTHORS README"

pkg_setup() {
	# NotHere is too broken to be included by default
	G2CONF="$(use_enable spell aspell)
		$(use_enable python)
		--enable-voip=no
		--enable-megaphone
		--disable-nothere
		--disable-gtk-doc"
}

src_install() {
	gnome2_src_install
	make_desktop_entry "${PN}" "Empathy" \
		"/usr/share/icons/hicolor/scalable/apps/${PN}.svg" \
		"Network;InstantMessaging"
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "Empathy needs telepathy's connection managers to use any protocol."
	elog "You'll need to install connection managers yourself."
	elog "MSN: net-voip/telepathy-butterfly"
	elog "Jabber and Gtalk: net-voip/telepathy-gabble"
	elog "IRC: net-irc/telepathy-idle"
}
