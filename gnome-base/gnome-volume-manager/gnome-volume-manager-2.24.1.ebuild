# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-volume-manager/gnome-volume-manager-2.24.1.ebuild,v 1.6 2009/03/18 15:09:31 armin76 Exp $

inherit gnome2 eutils

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="automount debug consolekit"

# TODO: libnotify support is optional but doesn't have a configure switch

RDEPEND=">=gnome-base/libgnomeui-2.1.5
	>=dev-libs/dbus-glib-0.71
	>=sys-apps/hal-0.5.9
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2
	>=x11-libs/libnotify-0.3
	>=gnome-base/gconf-2

	  gnome-base/nautilus
	>=gnome-base/gnome-mount-0.6

	consolekit? ( >=sys-auth/consolekit-0.2 )"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog README HACKING NEWS TODO"

pkg_setup() {
	# if consolekit is absent, g-v-m will fall back to the old
	# behavior of the pam_console time.
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable automount)
		$(use_enable consolekit multiuser)"
}

src_unpack() {
	gnome2_src_unpack

	# Fix most FreeBSD issues (bug #183442) -- local fallback wont work
	epatch "${FILESDIR}/${PN}-2.22.0-fbsd-support.patch"

	# Fix default totem command, bug #200999
	epatch "${FILESDIR}/${PN}-2.17.0-totem-dvd.patch"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To start the gnome-volume-manager daemon you need to configure"
	elog "it through it's preferences capplet. Also the HAL daemon (hald)"
	elog "needs to be running or it will shut down."
	elog
	elog "If you experience problems with automounting (windows opened"
	elog "twice or nothing happening on media insertion) try changing"
	elog "the status of the automount USE flag."
}
