# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gccxml/gccxml-0.7.0_pre20060311.ebuild,v 1.1 2006/10/10 21:03:34 g2boojum Exp $

inherit eutils
MY_PNV=${PN}_${PV/_pre/+cvs}.orig
S=${WORKDIR}/${MY_PNV/_/-}
DESCRIPTION="XML output extension to GCC"
HOMEPAGE="http://www.gccxml.org/"
SRC_URI="http://ftp.debian.org/debian/pool/main/g/${PN}/${MY_PNV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND=""

MYBUILDDIR=${WORKDIR}/build
src_unpack() {
	mkdir ${MYBUILDDIR}
	unpack ${A}
	cd ${S}
	# patch below taken from Debian
	sed -i -e 's/xatexit.c//' ${S}/GCC/libiberty/CMakeLists.txt
}
src_compile() {
	cd ${MYBUILDDIR}
	cmake ${S} -DCMAKE_INSTALL_PREFIX:PATH=/usr || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	cd ${MYBUILDDIR}
	make DESTDIR=${D} install || die
}
