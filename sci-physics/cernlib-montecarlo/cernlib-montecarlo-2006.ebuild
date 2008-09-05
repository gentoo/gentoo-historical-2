# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/cernlib-montecarlo/cernlib-montecarlo-2006.ebuild,v 1.4 2008/09/05 07:46:26 opfer Exp $

inherit eutils multilib fortran

DEB_PN=mclibs
DEB_PV=${PV}.dfsg.2
DEB_PR=1
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="Monte-carlo library and tools for the cernlib"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/cernlib"
LICENSE="GPL-2 LGPL-2 BSD"
SRC_URI="mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.diff.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/openmotif
	virtual/lapack
	dev-lang/cfortran
	sci-physics/cernlib"

DEPEND="${RDEPEND}
	virtual/latex-base
	x11-misc/imake
	x11-misc/makedepend"

S="${WORKDIR}/${DEB_PN}-${DEB_PV}.orig"

FORTRAN="gfortran g77 ifc"

src_unpack() {
	unpack ${A}
	epatch "${DEB_P}-${DEB_PR}".diff

	cd "${S}"
	cp debian/add-ons/Makefile .
	sed -i \
		-e 's:/usr/local:/usr:g' \
		Makefile || die "sed'ing the Makefile failed"

	einfo "Applying Debian patches"
	emake -j1 \
		DEB_BUILD_OPTIONS="${FORTRANC} ${nostrip}" \
		patch || die "make patch failed"

	# since we depend on cfortran, do not use the one from cernlib
	# (adapted from debian/cernlib-debian.mk)
	mv -f src/include/cfortran/cfortran.h \
		src/include/cfortran/cfortran.h.disabled
	# create local LaTeX cache directory
	mkdir -p .texmf-var
}

src_compile() {
	emake -j1 \
		DEB_BUILD_OPTIONS="${FORTRANC} nostrip" \
		|| die "emake failed"
}

src_install() {
	emake \
		DEB_BUILD_OPTIONS="${FORTRANC} nostrip" \
		DESTDIR="${D}" \
		install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt copyright || die "dodoc failed"
	newdoc add-ons/README README.add-ons || die "newdoc failed"
}
