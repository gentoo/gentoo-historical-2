# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksquares/ksquares-4.3.4.ebuild,v 1.2 2010/01/23 02:09:38 abcd Exp $

EAPI="2"

KMNAME="kdegames"
inherit games-ggz kde4-meta

DESCRIPTION="KSquares is an implementation of the game squares for KDE4"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +handbook"

src_prepare() {
	# cmake is doing this really weird
	sed -i \
		-e "s:register_ggz_module:#register_ggz_module:g" \
		${PN}/src/CMakeLists.txt || die "ggz removal failed"

	kde4-meta_src_prepare
}

src_install() {
	kde4-meta_src_install
	# and also we have to prepare the ggz dir
	insinto /usr/share/ggz/modules
	newins ${PN}/src/module.dsc ${P}.dsc || die
}

pkg_postinst() {
	kde4-meta_pkg_postinst
	games-ggz_pkg_postinst
}

pkg_postrm() {
	kde4-meta_pkg_postrm
	games-ggz_pkg_postrm
}
