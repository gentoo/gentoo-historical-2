# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/autodock_vina/autodock_vina-1.1.1.ebuild,v 1.1 2010/05/18 11:43:46 jlec Exp $

EAPI="3"

inherit eutils flag-o-matic versionator

MY_P="${PN}_$(replace_all_version_separators _)"

DESCRIPTION="Program for drug discovery, molecular docking and virtual screening"
HOMEPAGE="http://vina.scripps.edu/"
SRC_URI="http://vina.scripps.edu/download/${MY_P}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE="debug"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}/build/linux/release

src_prepare() {
	cd "${WORKDIR}"/${MY_P} && epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	local c_options

	use debug || c_options="-DNDEBUG"

	emake \
		BASE="${EPREFIX}"/usr/ \
		GPP="$(tc-getCXX)" \
		C_OPTIONS="${c_options}" \
		|| die
}

src_install() {
	dobin vina{,_split} || die
}
