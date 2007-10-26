# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/notification-daemon-xfce/notification-daemon-xfce-0.3.7.ebuild,v 1.15 2007/10/26 13:10:39 angelos Exp $

inherit autotools xfce44

xfce44

DESCRIPTION="Port of notification daemon for Xfce Desktop Environment"
HOMEPAGE="http://goodies.xfce.org/projects/applications/notification-daemon-xfce"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}.tar.bz2"

KEYWORDS="alpha amd64 ~arm ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=xfce-base/libxfcegui4-${XFCE_MASTER_VERSION}
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	>=xfce-base/xfce-mcs-manager-${XFCE_MASTER_VERSION}
	>=x11-libs/libsexy-0.1.3
	dev-libs/dbus-glib"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
	!x11-misc/notification-daemon"

XFCE_CONFIG="${XFCE_CONFIG} --enable-gradient-look --enable-mcs-plugin"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "/^AC_INIT/s/notification_daemon_version()/notification_daemon_version/" configure.in
	eautoconf
}

DOCS="AUTHORS ChangeLog NEWS README"
