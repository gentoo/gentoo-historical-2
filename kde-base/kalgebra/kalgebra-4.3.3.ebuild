# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalgebra/kalgebra-4.3.3.ebuild,v 1.2 2009/11/29 14:07:43 ssuominen Exp $

EAPI="2"

KMNAME="kdeedu"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="MathML-based graph calculator for KDE."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook +plasma readline"

DEPEND="
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="libkdeedu/kdeeduui"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with readline)
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with opengl OpenGL)"

	kde4-meta_src_configure
}

src_test() {
	# disable broken test
	sed -i -e '/mathmlpresentationtest/ s/^/#DO_NOT_RUN_TEST /' \
		"${S}"/"${PN}"/analitza/tests/CMakeLists.txt || \
		die "sed to disable mathmlpresentationtest failed."

	kde4-meta_src_test
}
