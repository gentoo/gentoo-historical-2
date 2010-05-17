# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-notifyd/xfce4-notifyd-0.1.0_p20100326.ebuild,v 1.3 2010/05/17 08:10:15 phajdan.jr Exp $

EAPI=2
EAUTORECONF=yes
inherit xfconf

DESCRIPTION="A simple notification daemon for Xfce4"
HOMEPAGE="http://spuriousinterrupt.org/projects/xfce4-notifyd"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug libsexy"

RDEPEND=">=xfce-base/libxfce4util-4.4
	>=xfce-base/libxfcegui4-4.5.3
	>=xfce-base/xfconf-0.1
	>=x11-libs/gtk+-2.10:2
	>=sys-apps/dbus-1
	>=dev-libs/dbus-glib-0.72
	>=gnome-base/libglade-2.6
	libsexy? ( >=x11-libs/libsexy-0.1.6 )
	!<x11-libs/libnotify-0.4.5
	!x11-misc/notification-daemon"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	xfce-base/exo"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	XFCONF="--enable-maintainer-mode
		--disable-dependency-tracking
		$(use_enable libsexy)
		$(xfconf_use_debug)"
}
