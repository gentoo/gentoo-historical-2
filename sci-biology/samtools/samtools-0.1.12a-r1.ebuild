# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/samtools/samtools-0.1.12a-r1.ebuild,v 1.1 2011/03/14 09:37:27 xarthisius Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Utilities for SAM (Sequence Alignment/Map), a format for large nucleotide sequence alignments"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86 ~x64-macos"

src_prepare() {
	sed -e '/^CFLAGS=/d' \
		-e "s/\$(CC) \$(CFLAGS)/& \$(LDFLAGS)/g" \
		-e "s/-shared/& \$(LDFLAGS)/" \
		-i "${S}"/{Makefile,misc/Makefile} || die #358563
	sed -i 's~/software/bin/python~/usr/bin/env python~' "${S}"/misc/varfilter.py || die
}

src_compile() {
	emake CC="$(tc-getCC)" dylib || die
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin samtools || die
	dobin $(find misc -type f -executable) || die
	dolib.so libbam.so.1 || die
	insinto /usr/include/bam
	doins bam.h bgzf.h faidx.h kaln.h khash.h kprobaln.h kseq.h ksort.h sam.h|| die
	insinto /usr/share/${PN}
	doins -r examples || die
	doman ${PN}.1 || die
	dodoc AUTHORS ChangeLog NEWS
}
