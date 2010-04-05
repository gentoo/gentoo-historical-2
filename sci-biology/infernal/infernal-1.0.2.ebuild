# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/infernal/infernal-1.0.2.ebuild,v 1.3 2010/04/05 12:14:58 phajdan.jr Exp $

EAPI="2"

DESCRIPTION="Inference of RNA alignments"
HOMEPAGE="http://infernal.janelia.org/"
SRC_URI="ftp://selab.janelia.org/pub/software/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi"
KEYWORDS="amd64 x86"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

src_configure() {
	econf --prefix="${D}/usr" \
		$(use_enable mpi) || die
}

src_install() {
	emake install || die
	(cd documentation/manpages; for i in *; do newman ${i} ${i/.man/.1}; done)
	insinto /usr/share/${PN}
	doins -r benchmarks tutorial intro matrices
	dodoc 00README* Userguide.pdf documentation/release-notes/*
}
