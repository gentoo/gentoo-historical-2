# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalzium/kalzium-4.3.3.ebuild,v 1.1 2009/11/02 20:35:59 wired Exp $

EAPI="2"

KMNAME="kdeedu"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="KDE: periodic table of the elements."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="editor debug +handbook +plasma solver"

COMMON_DEPEND="
	$(add_kdebase_dep libkdeedu)
	editor? ( >=sci-chemistry/openbabel-2.2 )
"
DEPEND="${COMMON_DEPEND}
	editor? ( >=dev-cpp/eigen-2.0.3 )
	solver? ( dev-ml/facile[ocamlopt] )
"
RDEPEND="${COMMON_DEPEND}"

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
	libkdeedu/libscience/
"

src_configure(){
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with editor Eigen2)
		$(cmake-utils_use_with editor OpenBabel2)
		$(cmake-utils_use_with editor OpenGL)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)"

	kde4-meta_src_configure
}
