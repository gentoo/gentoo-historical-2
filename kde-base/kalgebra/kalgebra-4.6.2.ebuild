# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalgebra/kalgebra-4.6.2.ebuild,v 1.4 2011/06/01 17:42:50 ranger Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdeedu"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="MathML-based graph calculator for KDE."
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma readline"

DEPEND="
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
"
KMEXTRA="
	libkdeedu/qtmmlwidget/
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.73-solaris-graph2d.patch
)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with readline)
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-meta_src_configure
}

src_test() {
	# disable broken test
	sed -i -e '/mathmlpresentationtest/ s/^/#DO_NOT_RUN_TEST /' \
		"${S}"/"${PN}"/analitza/tests/CMakeLists.txt || \
		die "sed to disable mathmlpresentationtest failed."

	kde4-meta_src_test
}
