# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfswitch-plugin/xfswitch-plugin-0.0.1.ebuild,v 1.7 2011/05/19 19:55:54 ssuominen Exp $

EAPI=4
inherit xfconf

DESCRIPTION="User switching plugin for the Xfce Panel"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfswitch-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

COMMON_DEPEND=">=x11-libs/gtk+-2.12:2
	>=xfce-base/libxfce4util-4.4
	>=xfce-base/libxfcegui4-4.4
	>=xfce-base/xfce4-panel-4.4"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gdm"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

pkg_setup() {
	XFCONF=( $(xfconf_use_debug) )
	DOCS=( AUTHORS ChangeLog NEWS README )
}
