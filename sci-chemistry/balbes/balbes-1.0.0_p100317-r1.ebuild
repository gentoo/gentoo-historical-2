# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/balbes/balbes-1.0.0_p100317-r1.ebuild,v 1.1 2010/05/12 10:29:36 jlec Exp $

EAPI="3"

FORTRAN="gfortran ifort"
CCP4VER="6.1.3"
PYTHON_DEPEND="2"

inherit eutils fortran python

DESCRIPTION="Automated molecular replacement (MR) pipeline"
HOMEPAGE="http://www.ysbl.york.ac.uk/~fei/balbes/index.html"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	ftp://ftp.ccp4.ac.uk/ccp4/${CCP4VER}/ccp4-${CCP4VER}-core-src.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="ccp4"
IUSE=""

COMMON_DEPEND="sci-libs/ccp4-libs"
RDEPEND="
	${COMMON_DEPEND}
	~sci-libs/balbes-db-${CCP4VER}
	!<=sci-chemistry/ccp4-apps-6.1.3-r1"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"/src

pkg_setup() {
	python_set_active_version 2
	fortran_pkg_setup
}

src_unpack() {
	unpack ${P}.tar.gz
	tar xvzf "${DISTDIR}"/ccp4-${CCP4VER}-core-src.tar.gz ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py/balbes
	python_convert_shebangs 2 "${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py/balbes
}

src_prepare() {
	mkdir "${WORKDIR}"/bin || die
	epatch "${FILESDIR}"/${PV}-makefile.patch
}

src_compile() {
	emake \
		BLANC_FORT="${FORTRANC} ${FFLAGS}" || die
}

src_install() {
	dobin \
		"${WORKDIR}"/bin/* \
		"${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py/balbes \
		|| die
}
