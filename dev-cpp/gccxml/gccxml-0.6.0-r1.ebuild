# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gccxml/gccxml-0.6.0-r1.ebuild,v 1.5 2006/07/21 02:28:40 psi29a Exp $

inherit versionator eutils
PVM="$(get_version_component_range 1-2)"
DESCRIPTION="XML output extension to GCC"
HOMEPAGE="http://www.gccxml.org/"
SRC_URI="http://www.gccxml.org/files/v${PVM}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 mips ppc ~sparc x86"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND=""

MYBUILDDIR=${WORKDIR}/build
src_unpack() {
	mkdir ${MYBUILDDIR}
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/obstack.h.diff
}
src_compile() {
	cd ${MYBUILDDIR}
	cmake ../${P} -DCMAKE_INSTALL_PREFIX:PATH=/usr || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	cd ${MYBUILDDIR}
	make DESTDIR=${D} install || die
}
