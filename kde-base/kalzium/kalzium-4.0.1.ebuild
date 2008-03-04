# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalzium/kalzium-4.0.1.ebuild,v 1.2 2008/03/04 03:34:03 jer Exp $

EAPI="1"

KMNAME=kdeedu
inherit kde4-meta

DESCRIPTION="KDE: periodic table of the elements."
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="cviewer debug htmlhandbook solver test"

COMMONDEPEND=">=kde-base/libkdeedu-${PV}:${SLOT}
	cviewer? ( >=dev-cpp/eigen-1.0.5
		>=sci-chemistry/openbabel-2.1
		virtual/opengl )"
DEPEND="${DEPEND} ${COMMONDEPEND}
	solver? ( dev-ml/facile )"
RDEPEND="${RDEPEND} ${COMMONDEPEND}"

KMEXTRACTONLY="libkdeedu/kdeeduui libkdeedu/libscience"

pkg_setup() {
	use cviewer && QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK} opengl"

	if use solver && ! built_with_use --missing true dev-lang/ocaml ocamlopt; then
		eerror "In order to build the solver for ${PN}, you first need"
		eerror "to have dev-lang/ocaml built with the ocamlopt useflag"
		eerror "in order to get a native code ocaml compiler"
		die "Please install dev-lang/ocaml with ocamlopt support"
	fi
	if use solver && ! built_with_use --missing true dev-ml/facile ocamlopt; then
		eerror "In order to build the solver for ${PN}, you first need"
		eerror "to have dev-ml/facile built with the ocamlopt useflag"
		eerror "in order to get the native code library"
		die "Please install dev-ml/facile with ocamlopt support"
	fi

	kde4-meta_pkg_setup
}

src_compile() {
	if use solver ; then
		# Compile the solver on its own as the cmake-based build is
		# currently broken. Fixes bug 206620.
		cd "${S}/${PN}/src/solver"
		emake || die "compiling the ocaml resolver failed"
		mkdir -p "${WORKDIR}/${PN}_build/${PN}/src/"
		cp * "${WORKDIR}/${PN}_build/${PN}/src/"
	fi

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with cviewer Eigen)
		$(cmake-utils_use_with cviewer OpenBabel2)
		$(cmake-utils_use_with cviewer OpenGL)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)"

	kde4-meta_src_compile
}
