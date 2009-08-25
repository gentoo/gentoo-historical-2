# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-places-plugin/xfce4-places-plugin-1.1.0.ebuild,v 1.1 2009/08/25 07:47:20 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="Places menu plug-in for panel, like GNOME's"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.6:2
	>=xfce-base/libxfce4util-4.3.90.2
	>=xfce-base/libxfcegui4-4.3.90.2
	xfce-base/thunar
	>=xfce-base/exo-0.3.1.1
	xfce-base/xfce4-panel"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

# temp. hack, dropped in next version
RESTRICT="test"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
}
