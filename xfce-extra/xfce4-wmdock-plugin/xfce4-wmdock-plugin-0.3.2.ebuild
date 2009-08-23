# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-wmdock-plugin/xfce4-wmdock-plugin-0.3.2.ebuild,v 1.1 2009/08/23 17:20:36 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="a compatibility layer for running WindowMaker dockapps on Xfce4."
HOMEPAGE="http://www.xfce.org"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.3/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.6:2
	>=xfce-base/xfce4-panel-4.3.99.1
	>=xfce-base/libxfcegui4-4.3.90.2
	>=xfce-base/libxfce4util-4.3.90.2
	>=x11-libs/libwnck-2.8.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

pkg_setup() {
	DOCS="AUTHORS ChangeLog README TODO"
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
}

src_prepare() {
	xfconf_src_prepare
	echo panel-plugin/wmdock.desktop.in.in >> po/POTFILES.skip
}
