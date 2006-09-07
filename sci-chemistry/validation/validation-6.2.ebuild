# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/validation/validation-6.2.ebuild,v 1.4 2006/09/07 00:50:32 dberkholz Exp $

inherit eutils toolchain-funcs multilib

# pdb-extract includes a newer 'validation' than 'validation' tarball does,
# and the filterlib from pdb-extract is incompatible with the validation tarball
MY_PN="pdb-extract"
MY_PV="1.700"
MY_P="${MY_PN}-v${MY_PV}-prod-src"
DESCRIPTION="Set of tools used by the Protein Data Base (PDB) for processing and checking structure data"
HOMEPAGE="http://sw-tools.pdb.org/apps/VAL/index.html"
SRC_URI="http://sw-tools.pdb.org/apps/PDB_EXTRACT/${MY_P}.tar.gz"
LICENSE="PDB"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND="sci-libs/rcsb-data"
DEPEND="${RDEPEND}
	sci-chemistry/pdb-extract"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/respect-cflags-and-fix-install.patch
	cd ${S}

	# Get rid of unneeded directories, to make sure we use system files
	ebegin "Deleting redundant directories"
	rm -rf btree-obj* ciflib-common* cifobj-common* cif-table-obj* maxit* \
		misclib* regex* pdb-extract*
	eend

	sed -i \
		-e "s:^\(CCC=\).*:\1$(tc-getCXX):g" \
		-e "s:^\(GINCLUDE=\).*:\1-I${ROOT}usr/include/rcsb:g" \
		-e "s:^\(LIBDIR=\).*:\1${ROOT}usr/$(get_libdir):g" \
		${S}/etc/make.*
}

src_install() {
	exeinto /usr/bin
	doexe bin/*
	dolib.a lib/*
	insinto /usr/include/rcsb
	doins include/*
	dodoc ${FILESDIR}/README*
}
