# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-cd-burner/nautilus-cd-burner-2.16.1.ebuild,v 1.1 2006/10/12 08:17:46 leio Exp $

inherit gnome2

DESCRIPTION="CD and DVD writer plugin for Nautilus"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cdr dvdr static"

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
	>=sys-apps/dbus-0.6.0

	cdr? ( virtual/cdrtools )
	dvdr? ( >=app-cdr/dvd+rw-tools-6.1 )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --enable-gnome-mount $(use_enable static)"
}
