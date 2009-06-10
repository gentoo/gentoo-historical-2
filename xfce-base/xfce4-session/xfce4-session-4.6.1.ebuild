# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4-session/xfce4-session-4.6.1.ebuild,v 1.4 2009/06/10 07:39:40 fauli Exp $

inherit xfce4

xfce4_core

DESCRIPTION="Session manager"
HOMEPAGE="http://www.xfce.org/projects/xfce4-session/"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug gnome"

RDEPEND="gnome-base/libglade
	dev-libs/dbus-glib
	sys-apps/dbus
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libwnck
	x11-apps/iceauth
	>=xfce-base/libxfce4util-${XFCE_VERSION}
	>=xfce-base/libxfcegui4-${XFCE_VERSION}
	>=xfce-base/xfconf-${XFCE_VERSION}
	>=xfce-base/xfce-utils-${XFCE_VERSION}
	games-misc/fortune-mod
	gnome? ( gnome-base/gconf
		gnome-base/gnome-keyring )"
DEPEND="${RDEPEND}
	dev-util/intltool"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	XFCE_CONFIG+=" $(use_enable gnome)"
}
