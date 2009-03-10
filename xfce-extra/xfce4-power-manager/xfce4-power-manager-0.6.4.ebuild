# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-power-manager/xfce4-power-manager-0.6.4.ebuild,v 1.1 2009/03/10 14:43:11 angelos Exp $

EAPI=1

inherit xfce4

XFCE_VERSION=4.5.90

xfce4_goodies

DESCRIPTION="Xfce4 power manager"
KEYWORDS="~amd64 ~x86"
IUSE="debug libnotify"

RDEPEND=">=dev-libs/dbus-glib-0.70
	>=dev-libs/glib-2.14:2
	>=sys-apps/dbus-0.60
	>=sys-apps/hal-0.5.6
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4util-${XFCE_VERSION}
	>=xfce-base/libxfcegui4-${XFCE_VERSION}
	>=xfce-base/xfconf-${XFCE_VERSION}"
DEPEND="${RDEPEND}
	dev-util/intltool"

pkg_setup() {
	XFCE_CONFIG+=" $(use_enable libnotify)"
}
