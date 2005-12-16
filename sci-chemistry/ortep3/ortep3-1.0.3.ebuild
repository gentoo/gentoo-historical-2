# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ortep3/ortep3-1.0.3.ebuild,v 1.1 2005/12/16 05:36:57 spyderous Exp $

inherit fortran

FORTRAN="g77"
DESCRIPTION="Thermal ellipsoid plot program for crystal structure illustrations"
HOMEPAGE="http://www.ornl.gov/sci/ortep/"
SRC_URI="ftp://ftp.ornl.gov/pub/ortep/src/ortep.f"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND="sci-libs/pgplot
	|| ( x11-libs/libX11 virtual/x11 )"
DEPEND="${RDEPEND}"
S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${A} ${S}
}

src_compile() {
	COMMAND="${FORTRANC} -o ortep3 ${FFLAGS:- -O2} ortep.f -lpgplot -lX11"
	echo ${COMMAND}
	${COMMAND} || die "Compilation failed"
}

src_install() {
	dobin ortep3
}
