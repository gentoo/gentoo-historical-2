# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/fast-user-switch-applet/fast-user-switch-applet-2.18.0.ebuild,v 1.5 2007/08/08 22:26:30 armin76 Exp $

inherit eutils gnome2

DESCRIPTION="Fast User Switching Applet for Gnome Desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/glib
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2.0
	gnome-base/gconf
	>=gnome-base/gnome-panel-2.0
	gnome-base/gdm
	x11-libs/libXmu
	x11-libs/libXau
	x11-libs/libSM"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/pkgconfig-0.9
	>=sys-devel/autoconf-2.53
	>=dev-util/intltool-0.35
	>=app-text/scrollkeeper-0.1.4
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.3"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"

pkg_setup() {
	G2CONF="${G2CONF} --with-gdm-config=/usr/share/gdm/defaults.conf"
}
