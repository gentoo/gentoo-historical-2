# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/xfoil/xfoil-6.94.ebuild,v 1.3 2005/02/02 17:47:40 kugelfang Exp $

inherit toolchain-funcs fortran

MY_PN="${PN}"
MY_PV="${PV/./}"
MY_P="${MY_PN}${MY_PV}"

DESCRIPTION="design and analysis of subsonic isolated airfoils"
HOMEPAGE="http://raphael.mit.edu/xfoil/"
SRC_URI="http://raphael.mit.edu/xfoil/${MY_P}.tar.gz
	doc? ( http://raphael.mit.edu/xfoil/xfoil_doc.ps
		http://raphael.mit.edu/xfoil/xfoil_doc.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="virtual/blas
	sci-libs/blas-config
	virtual/x11"

S=${WORKDIR}/XFOIL${MY_PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	[ -z "${FFLAGS}" ] && FFLAGS="${CFLAGS}" # because gcc-config doesn't do it yet

	# As defined in toolchain-funcs.eclass
	echo "CC = $(tc-getCC)" >>plotlib/config.make

	# As defined in fortran.eclass
	echo "FC = ${FORTRANC}" >>plotlib/config.make

	echo "CFLAGS += ${CFLAGS}" >>plotlib/config.make
	echo "FFLAGS += ${FFLAGS}" >>plotlib/config.make

	sed -i bin/Makefile \
	-e "s/^\(FC.*\)/FC = ${FORTRANC}/g" \
	-e "s/^\(CC.*\)/CC = $(tc-getCC)/g" \
	-e "s/^\(FFLAGS .*\)/FFLAGS = ${FFLAGS}/g" \
	-e "s/^\(FFLOPT .*\)/FFLOPT = \$(FFLAGS)/g" \
	-e "s/^\(FFLAGS2 .*\)/FFLAGS2 = \$(FFLAGS)/g"
}

src_compile() {
	cd ${S}/plotlib
	emake || die "failed to build plotlib"
	cd ${S}/bin
	for i in xfoil pplot pxplot; do
		emake ${i} || die "failed to build ${i}"
	done
}

src_install() {
	dobin bin/pplot bin/pxplot bin/xfoil
	dodoc version_notes.txt  xfoil_doc.txt sessions.txt README
	use doc && dodoc ${DISTDIR}/xfoil_doc.ps ${DISTDIR}/xfoil_doc.pdf
	docinto runs
	dodoc runs/*
}
