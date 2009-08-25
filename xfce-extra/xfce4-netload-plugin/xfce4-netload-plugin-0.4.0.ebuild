# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-netload-plugin/xfce4-netload-plugin-0.4.0.ebuild,v 1.1 2009/08/25 07:52:46 ssuominen Exp $

EAUTORECONF=yes
EINTLTOOLIZE=yes
EAPI=2
inherit xfconf

DESCRIPTION="Netload plugin for Xfce4 panel"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.4/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=xfce-base/xfce4-panel-4.3.20"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

pkg_setup() {
	PATCHES=( "${FILESDIR}/${P}-asneeded.patch" )
	DOCS="AUTHORS ChangeLog README"
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
}

src_prepare() {
	sed -i -e "/^AC_INIT/s/netload_version()/netload_version/" configure.ac \
		|| die "sed failed"
	xfconf_src_prepare
}
