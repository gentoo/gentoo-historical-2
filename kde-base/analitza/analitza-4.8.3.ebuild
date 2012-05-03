# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/analitza/analitza-4.8.3.ebuild,v 1.1 2012/05/03 20:07:50 johu Exp $

EAPI=4

KDE_HANDBOOK="never"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="KDE library for mathematical features"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug readline"

DEPEND="
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

add_blocker kalgebra 4.7.50

RESTRICT=test
# bug 397705

PATCHES=( "${FILESDIR}/${PN}-solaris-graph2d.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with readline)
	)

	kde4-base_src_configure
}
