# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalgebra/kalgebra-4.7.4.ebuild,v 1.3 2012/01/16 21:23:54 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="optional"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="MathML-based graph calculator for KDE."
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma readline"

DEPEND="
	$(add_kdebase_dep libkdeedu)
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
"
KMEXTRA="
	libkdeedu/qtmmlwidget/
"

RESTRICT="test"
# bug 382561

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.73-solaris-graph2d.patch
)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with readline)
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-base_src_configure
}

src_test() {
	# disable broken test
	sed -i -e '/mathmlpresentationtest/ s/^/#DO_NOT_RUN_TEST /' \
		"${S}"/analitza/tests/CMakeLists.txt || \
		die "sed to disable mathmlpresentationtest failed."

	kde4-base_src_test
}
