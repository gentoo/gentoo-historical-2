# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-quicklauncher-plugin/xfce4-quicklauncher-plugin-1.9.4-r1.ebuild,v 1.8 2010/08/29 18:06:30 armin76 Exp $

EAUTORECONF=yes
EINTLTOOLIZE=yes
EAPI=2
inherit xfconf

DESCRIPTION="Xfce4 panel quicklauncher plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/1.9/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
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
	PATCHES=( "${FILESDIR}/${P}-X-XFCE-Module-Path.patch" )
}

src_prepare() {
	sed -i \
		-e "/^AC_INIT/s/quicklauncher_version()/quicklauncher_version/" \
		configure.ac || die
	xfconf_src_prepare
}
