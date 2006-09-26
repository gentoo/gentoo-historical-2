# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coot-data/coot-data-1.ebuild,v 1.2 2006/09/26 07:57:12 dberkholz Exp $

DESCRIPTION="Data for the Crystallographic Object-Oriented Toolkit"
HOMEPAGE="http://www.ysbl.york.ac.uk/~emsley/coot/"
SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/extras/reference-structures.tar.gz
	http://www.ysbl.york.ac.uk/~emsley/software/extras/refmac-lib-data-monomers.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/share/coot
	ebegin "Copying reference structures to ${D}/usr/share/coot/"
	cp -R ${WORKDIR}/reference-structures ${D}/usr/share/coot/
	eend
	ebegin "Copying monomer library to ${D}/usr/share/coot/"
	cp -R ${WORKDIR}/lib ${D}/usr/share/coot/
	eend

	# Coot looks in the wrong spot for the monomer library
	# Listens to ccp4's CCP4_LIB rather than CLIBD_MON
	cat << EOF >> ${T}/coot
COOT_REFMAC_LIB_DIR="${ROOT}usr/share/coot/lib"
EOF

	newenvd ${T}/coot 20coot
}
