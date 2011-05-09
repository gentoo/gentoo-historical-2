# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalzium/kalzium-4.6.2.ebuild,v 1.3 2011/05/09 22:19:01 hwoarang Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdeedu"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit flag-o-matic kde4-meta

DESCRIPTION="KDE: periodic table of the elements."
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="editor debug +plasma solver"

RDEPEND="
	$(add_kdebase_dep libkdeedu)
	editor? ( >=sci-chemistry/openbabel-2.2 )
"
DEPEND="${RDEPEND}
	editor? ( >=dev-cpp/eigen-2.0.3:2 )
	solver? ( dev-ml/facile[ocamlopt] )
"

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
	libkdeedu/libscience/
"

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	mycmakeargs=(
		$(cmake-utils_use_with editor Eigen2)
		$(cmake-utils_use_with editor OpenBabel2)
		$(cmake-utils_use_with editor OpenGL)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)
	)

	kde4-meta_src_configure
}
