# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-volstatus-icon/xfce4-volstatus-icon-0.1.0.ebuild,v 1.9 2008/03/24 12:59:44 klausman Exp $

inherit eutils xfce44

xfce44

DESCRIPTION="Systray status icon for safe unmount/eject of volumes"
HOMEPAGE="http://goodies.xfce.org"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}${COMPRESS}"

KEYWORDS="alpha amd64 ia64 ~ppc x86"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.10
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	>=xfce-base/libxfcegui4-${XFCE_MASTER_VERSION}
	>=xfce-extra/exo-0.3.2
	>=sys-apps/hal-0.5.9
	dev-libs/dbus-glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

pkg_setup() {
	if ! built_with_use xfce-extra/exo hal; then
		die "Re-emerge xfce-extra/exo with USE hal."
	fi
}

DOCS="AUTHORS ChangeLog NEWS README TODO"
