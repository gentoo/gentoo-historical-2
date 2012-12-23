# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/espresso++/espresso++-1.3.1.ebuild,v 1.3 2012/12/23 00:26:04 ottxor Exp $

EAPI=4

PYTHON_DEPEND="2:2.6"

inherit cmake-utils python

DESCRIPTION="extensible, flexible, fast and parallel simulation software for soft matter research"
HOMEPAGE="https://www.espresso-pp.de"

if [[ ${PV} = 9999 ]]; then
	EHG_REPO_URI="https://hg.berlios.de/repos/espressopp"
	EHG_REVISION="default"
	inherit mercurial
else
	SRC_URI="https://www.espresso-pp.de/Download/${PN%++}pp_${PV//./_}.tgz"
	S="${WORKDIR}/${PN%++}pp"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
IUSE="-system-boost"

RDEPEND="
	system-boost? ( dev-libs/boost[python,mpi] )
	virtual/mpi
	"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	mycmakeargs=(
	$(cmake-utils_use system-boost EXTERNAL_BOOST)
	)
	cmake-utils_src_configure
}
