# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/superkaramba/superkaramba-4.6.3.ebuild,v 1.2 2011/06/08 23:48:03 tomka Exp $

EAPI=3

KMNAME="kdeutils"
PYTHON_DEPEND="python? 2"
inherit python kde4-meta

DESCRIPTION="A tool to create interactive applets for the KDE desktop."
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug python"

DEPEND="
	media-libs/qimageblitz
	python? ( $(add_kdebase_dep pykde4) )
"
RDEPEND="${DEPEND}
	python? ( $(add_kdebase_dep krosspython) )
"

PATCHES=( "${FILESDIR}/${PN}-as-needed.patch" )

pkg_setup() {
	kde4-meta_pkg_setup
	python_set_active_version 2
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with python PythonLibs)
	)

	kde4-meta_src_configure
}
