# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-sendto/nautilus-sendto-1.1.5-r1.ebuild,v 1.1 2009/08/02 22:30:59 eva Exp $

EAPI="2"

inherit gnome2 eutils autotools

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth +mail empathy gajim cdr pidgin upnp"

RDEPEND=">=x11-libs/gtk+-2.12
	>=dev-libs/glib-2.6
	>=gnome-base/libglade-2.5.1
	>=gnome-base/nautilus-2.14
	>=gnome-base/gconf-2.13.0
	bluetooth? (
		|| ( >=net-wireless/gnome-bluetooth-2.27
			 >=net-wireless/bluez-gnome-1.8 )
		>=dev-libs/dbus-glib-0.60 )
	cdr? (
		|| ( >=app-cdr/brasero-2.26.0[nautilus]
			 >=gnome-extra/nautilus-cd-burner-2.24.0 ) )
	mail? ( >=gnome-extra/evolution-data-server-1.5.3 )
	empathy? ( >=net-im/empathy-2.25.5 )
	gajim? ( net-im/gajim
			 >=dev-libs/dbus-glib-0.60 )
	pidgin? ( >=net-im/pidgin-2.0.0 )
	upnp? ( >=net-libs/gupnp-av-0.2.1 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=gnome-base/gnome-common-0.12
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

_use_plugin() {
	if use ${1}; then
		G2CONF="${G2CONF}${2:-"${1}"},"
	fi
}

pkg_setup() {
	G2CONF="${G2CONF} --with-plugins=removable-devices,"
	_use_plugin bluetooth
	_use_plugin cdr nautilus-burn
	_use_plugin mail evolution
	_use_plugin empathy
	_use_plugin pidgin
	_use_plugin gajim
	_use_plugin upnp
}

src_prepare() {
	gnome2_src_prepare

	# Fix plugin versioning for pidgin plugin
	epatch "${FILESDIR}"/${P}-pidgin-plugin-versioning.patch

	# Fix long description for plugins, bug #271100
	epatch "${FILESDIR}/${P}-long-description.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! use mail; then
		ewarn "You have disabled mail support, this will remove support for all mail clients"
	fi

	if use pidgin; then
		elog "To enable SendTo support in pidgin, you must enable the plugin in pidgin"
		elog "Check Tools -> Preferences -> Plugins in the pidgin menu."
	fi
}
