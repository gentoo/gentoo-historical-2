# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/vienna-rna/vienna-rna-1.6.1.ebuild,v 1.1 2006/09/14 00:13:46 ribosome Exp $

inherit toolchain-funcs

DESCRIPTION="The Vienna RNA Package - RNA secondary structure prediction and comparison"
LICENSE="vienna-rna"
HOMEPAGE="http://www.tbi.univie.ac.at/~ivo/RNA"
SRC_URI="http://www.tbi.univie.ac.at/~ivo/RNA/ViennaRNA-${PV}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="~x86 ~ppc"

DEPEND="dev-lang/perl
	media-libs/gd"

S="${WORKDIR}/ViennaRNA-${PV}"

src_compile() {
	econf --with-cluster || die "Configuration failed."
	cd "${S}"/RNAforester/g2-0.70
	sed -e "s:LIBDIR = /usr/lib:LIBDIR = ${D}/usr/lib:" \
		-e "s:INCDIR = /usr/include:INCDIR = ${D}/usr/include:" \
		-i Makefile || die "Failed patching RNAForester build system."
	cd "${S}"
	emake || die "Compilation failed."
	cd "${S}"/Readseq
	sed -e "s:CC=cc:CC=$(tc-getCC):" -e "s:CFLAGS=:CFLAGS=${CFLAGS}:" \
		-i Makefile || die "Failed patching readseq Makefile."
	make || die "Failed to compile readseq."
	# TODO: Add (optional?) support for the NCBI toolkit.
}

src_install() {
	make install DESTDIR="${D}" || die "Installation failed."
	dodoc AUTHORS ChangeLog NEWS README THANKS || \
		die "Failed to install documentation."
	newbin Readseq/readseq readseq-vienna || die \
		"Installing readseq failed."
	dodoc Readseq/Readseq.help || die \
		"Readseq Documentation installation failed."
	newdoc Readseq/Readme README.readseq || die \
		"Installing readseq Readme failed."
}
