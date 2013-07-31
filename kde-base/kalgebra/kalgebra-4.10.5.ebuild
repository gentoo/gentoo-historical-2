# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalgebra/kalgebra-4.10.5.ebuild,v 1.5 2013/07/31 19:58:50 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="MathML-based graph calculator for KDE."
HOMEPAGE="http://www.kde.org/applications/education/kalgebra
http://edu.kde.org/kalgebra"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma readline"

DEPEND="
	$(add_kdebase_dep analitza)
	$(add_kdebase_dep libkdeedu)
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with readline)
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-base_src_configure
}
