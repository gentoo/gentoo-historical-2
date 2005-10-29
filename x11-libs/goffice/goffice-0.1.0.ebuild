# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/goffice/goffice-0.1.0.ebuild,v 1.1 2005/10/29 04:51:40 joem Exp $

inherit eutils gnome2

DESCRIPTION="GOffice is a library of document-centric objects and utilities
building on top of GLib and Gtk+ and used by software such as Gnumeric."
HOMEPAGE="http://freshmeat.net/projects/goffice/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome"
#cairo support broken and -gtk broken

RDEPEND=">=dev-libs/glib-2.6.3
		>=gnome-extra/libgsf-1.13.1
		>=dev-libs/libxml2-2.4.12
		>=x11-libs/pango-1.8.2
		>=x11-libs/gtk+-2.6
		>=gnome-base/libglade-2.3.6
		>=gnome-base/libgnomeprint-2.8.2
		>=media-libs/libart_lgpl-2.3.11
		gnome? ( >=gnome-base/gconf-2
					>=gnome-base/libgnomeui-2 )"

DEPEND="${RDEPEND}
		dev-util/pkgconfig
		>=dev-util/intltool-0.29"

pkg_setup() {
	if use gnome && ! built_with_use gnome-extra/libgsf gnome; then
		eerror "Please rebuild gnome-extra/libgsf with gnome support enabled"
		eerror "USE=\"gnome\" emerge gnome-extra/libgsf"
		eerror "or add  \"gnome\" to your USE string in /etc/make.conf"
		die "No Gnome support found in libgsf"
	fi
}

G2CONF="${G2CONF} $(use_with gnome)"
USE_DESTDIR="1"

DOCS="AUTHORS BUGS COPYING ChangeLog INSTALL MAINTAINERS NEWS README"
