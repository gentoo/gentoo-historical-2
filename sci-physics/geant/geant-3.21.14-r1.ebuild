# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/geant/geant-3.21.14-r1.ebuild,v 1.3 2008/06/29 07:57:53 tove Exp $

DEB_PN=geant321
DEB_PV=${PV}.dfsg
DEB_PR=8
DEB_P=${DEB_PN}_${DEB_PV}

inherit eutils multilib fortran

DESCRIPTION="CERN's detector description and simulation Tool"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/geant/index.html"

LICENSE="GPL-2 LGPL-2 BSD"
SRC_URI="mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.diff.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/openmotif
	virtual/lapack
	dev-lang/cfortran
	sci-physics/cernlib
	sci-physics/paw"

DEPEND="${RDEPEND}
	virtual/latex-base
	x11-misc/imake
	x11-misc/makedepend"

S="${WORKDIR}/${DEB_PN}-${DEB_PV}.orig"

KEYWORDS="~amd64 ~x86"

FORTRAN="gfortran g77 ifc"

src_unpack() {
	unpack ${A}
	epatch "${DEB_P}-${DEB_PR}".diff
	rm -f ${DEB_P}-${DEB_PR}.diff
	cd "${S}"
	cp debian/add-ons/Makefile .
	export DEB_BUILD_OPTIONS="${FORTRANC} nostrip nocheck"
	sed -i \
		-e 's:/usr/local:/usr:g' \
		Makefile || die "sed'ing the Makefile failed"

	einfo "Applying Debian patches"
	emake -j1 patch || die "debian patch failed"

	# since we depend on cfortran, do not use the one from cernlib
	rm -f src/include/cfortran/cfortran.h
}

src_compile() {
	# create local LaTeX cache directory
	mkdir -p .texmf-var
	emake -j1 cernlib-indep cernlib-arch || die "emake failed"
}

src_test_() {
	LD_LIBRARY_PATH="${S}"/shlib \
		emake -j1 cernlib-test || die "emake test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt NEWS copyright || die "dodoc failed"
	newdoc add-ons/README README.add-ons || die "newdoc failed"
}
