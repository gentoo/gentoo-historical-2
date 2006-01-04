# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/hmmer/hmmer-2.3.2-r1.ebuild,v 1.6 2006/01/04 23:36:18 ribosome Exp $

DESCRIPTION="Sequence analysis using profile hidden Markov models"
LICENSE="GPL-2"
HOMEPAGE="http://hmmer.wustl.edu/"
SRC_URI="ftp://ftp.genetics.wustl.edu/pub/eddy/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
IUSE="pvm threads"
KEYWORDS="amd64 ~ppc ~ppc-macos ~sparc x86"

DEPEND="pvm? ( sys-cluster/pvm )"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=${D}/usr \
		--exec_prefix=${D}/usr \
		--mandir=${D}/usr/share/man \
		--enable-lfs \
		$(use_enable pvm) \
		$(use_enable threads) || die
	emake || die
}

src_install() {
	einstall || die

	cd src
	dolib libhmmer.a
	insinto /usr/include/hmmer
	doins *.h

	cd ../squid
	dobin afetch alistat compalign compstruct revcomp seqstat seqsplit sfetch shuffle sreformat sindex weight translate
	dolib libsquid.a
	insinto /usr/include/hmmer
	doins *.h

	cd ..
	dodoc NOTES
	newdoc 00README README
	insinto /usr/share/doc/${PF}
	doins Userguide.pdf
}

src_test() {
	make check
}
