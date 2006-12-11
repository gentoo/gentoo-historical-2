# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mustang/mustang-3.ebuild,v 1.2 2006/12/11 06:18:35 dberkholz Exp $

inherit toolchain-funcs

MY_PN="MUSTANG"
SRC_P="${PN}_v.${PV}"
MY_P="${MY_PN}_v.${PV}"
DESCRIPTION="MUltiple STructural AligNment AlGorithm."
HOMEPAGE="http://www.cs.mu.oz.au/~arun/mustang/"
SRC_URI="${HOMEPAGE}${SRC_P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_compile() {
	emake \
		CPP=$(tc-getCXX) \
		CPPFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_test() {
	./bin/MUSTANG_v.${PV} -f ./data/test/test_zf-CCHH
}

src_install() {
	newbin bin/MUSTANG_v.3 mustang
	dodoc README.txt
}

pkg_postinst() {
	elog "If you use this program for an academic paper, please cite:"
	elog "Arun S. Konagurthu, James C. Whisstock, Peter J. Stuckey, and Arthur M. Lesk"
	elog "Proteins: Structure, Function, and Bioinformatics. 64(3):559-574, Aug. 2006"
}
