# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/seaview/seaview-1-r1.ebuild,v 1.1 2004/12/23 21:44:42 ribosome Exp $

DESCRIPTION="A graphical multiple sequence alignment editor"
HOMEPAGE="http://pbil.univ-lyon1.fr/software/${PN}.html"
SRC_URI="ftp://pbil.univ-lyon1.fr/pub/mol_phylogeny/${PN}/${PN}.tar"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

DEPEND="x11-libs/fltk
	sci-biology/clustalw"

S=${WORKDIR}

src_compile() {
	# Corrects location of libfltk.
	CFLAGS="${CFLAGS} -c -I/usr/include/fltk-1.1"
	sed -ie 's:-L$(FLTK)/lib:-L/usr/lib/fltk-1.1:' Makefile

	emake -e || die
}

src_install() {
	dobin seaview seaview_align.sh
	insinto /usr/share/${PN}
	doins protein.mase seaview.help

	# Sets the path for the package's help file.
	insinto /etc/env.d
	doins ${FILESDIR}/29seaview
}
