# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-quicklauncher-plugin/xfce4-quicklauncher-plugin-1.9.4.ebuild,v 1.2 2009/08/25 19:29:02 mr_bones_ Exp $

EAUTORECONF=yes
ELIBTOOLIZE=yes
EAPI=2
inherit xfconf

DESCRIPTION="Xfce4 panel quicklauncher plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/1.9/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=xfce-base/xfce4-panel-4.3.20
	>=xfce-base/libxfcegui4-4.3.20"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

pkg_setup() {
	DOCS="AUTHORS ChangeLog TODO"
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
}

src_prepare() {
	sed -i -e "/^AC_INIT/s/quicklauncher_version()/quicklauncher_version/" \
		configure.ac || die "sed failed"
	xfconf_src_prepare
}
