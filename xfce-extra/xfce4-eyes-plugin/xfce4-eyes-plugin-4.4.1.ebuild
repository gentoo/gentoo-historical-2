# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-eyes-plugin/xfce4-eyes-plugin-4.4.1.ebuild,v 1.5 2011/03/22 20:52:02 xarthisius Exp $

EAPI=3
inherit xfconf

DESCRIPTION="panel plugin that adds eyes which watch your every step"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-eyes-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/4.4/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.6:2
	>=xfce-base/xfce4-panel-4.3.99.1
	>=xfce-base/libxfce4util-4.3.90.2
	>=xfce-base/libxfcegui4-4.3.90.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

pkg_setup() {
	XFCONF=(
		--disable-dependency-tracking
		$(xfconf_use_debug)
		)

	DOCS="AUTHORS ChangeLog NEWS README"
}
