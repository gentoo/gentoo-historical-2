# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/superkaramba/superkaramba-4.10.4.ebuild,v 1.7 2013/08/01 00:03:48 johu Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit python-single-r1 kde4-base

DESCRIPTION="A tool to create interactive applets for the KDE desktop."
HOMEPAGE="http://kde.org/applications/utilities/superkaramba
http://utils.kde.org/projects/superkaramba"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	media-libs/qimageblitz
	x11-libs/libX11
	x11-libs/libXrender
	python? (
		${PYTHON_DEPS}
		$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}")
	)
"
RDEPEND="${DEPEND}
	python? ( $(add_kdebase_dep krosspython "${PYTHON_USEDEP}") )
"

pkg_setup() {
	python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with python PythonLibs)
	)

	kde4-base_src_configure
}
