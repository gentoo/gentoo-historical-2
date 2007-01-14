# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-cd-burner/nautilus-cd-burner-2.16.2.ebuild,v 1.9 2007/01/14 02:01:34 kloeri Exp $

inherit gnome2 eutils

DESCRIPTION="CD and DVD writer plugin for Nautilus"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sh sparc x86"
IUSE="cdr dvdr"

RDEPEND=">=gnome-base/gnome-vfs-2.1.3.1
	>=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.14
	>=gnome-base/eel-2.14
	>=gnome-base/nautilus-2.15.3
	>=gnome-base/gconf-2
	>=gnome-base/gnome-mount-0.4
	>=sys-apps/hal-0.5.7
	||	(
			>=dev-libs/dbus-glib-0.71
			( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.6.0 )
		)
	cdr? ( virtual/cdrtools )
	dvdr? ( >=app-cdr/dvd+rw-tools-6.1 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --enable-gnome-mount"
}
