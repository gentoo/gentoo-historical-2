# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfswitch-plugin/xfswitch-plugin-0.0.1.ebuild,v 1.3 2009/09/22 15:18:15 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="User switching plugin for the Xfce4 Panel"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfswitch-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

COMMON_DEPEND=">=x11-libs/gtk+-2.12:2
	>=xfce-base/libxfce4util-4.4
	>=xfce-base/libxfcegui4-4.4
	>=xfce-base/xfce4-panel-4.4"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gdm"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
}
