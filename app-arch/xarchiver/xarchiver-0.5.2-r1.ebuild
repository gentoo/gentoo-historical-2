# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/xarchiver/xarchiver-0.5.2-r1.ebuild,v 1.4 2010/02/28 18:53:14 nixnut Exp $

EAPI=2
inherit xfconf

DESCRIPTION="a GTK+ based and advanced archive manager that can be used with Thunar"
HOMEPAGE="http://xarchiver.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.10:2
	>=dev-libs/glib-2.10:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-stack-smash.patch )
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)"
}

src_install() {
	xfconf_src_install

	rm "${D}"/usr/share/doc/${PN}/COPYING
	mv "${D}"/usr/share/doc/{${PN},${PF}}
}

pkg_postinst() {
	xfconf_pkg_postinst
	elog "You need external programs for some formats, including"
	elog "7zip - app-arch/p7zip"
	elog "arj - app-arch/unarj app-arch/arj"
	elog "lha - app-arch/lha"
	elog "lzop - app-arch/lzop"
	elog "rar - app-arch/unrar app-arch/rar"
	elog "zip - app-arch/unzip app-arch/zip"
	elog "Make sure to install xfce-extra/thunar-archive-plugin."
}
