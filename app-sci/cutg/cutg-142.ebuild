# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/cutg/cutg-142.ebuild,v 1.2 2004/09/29 23:17:19 ribosome Exp $

DESCRIPTION="Codon usage tables calculated from GenBank"
HOMEPAGE="http://www.kazusa.or.jp/codon/"
SRC_URI="ftp://ftp.kazusa.or.jp/pub/codon/current/compressed/CUTG.${PV}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="no-emboss no-rawdb"

S=${WORKDIR}

src_compile() {
	# Index the database for use with emboss if emboss is installed and
	# the user did not explicitly request not to index the database.
	if [ -e /usr/bin/cutgextract ] && ! use no-emboss; then
		mkdir CODONS
		einfo "Indexing CUTG for usage with EMBOSS."
		EMBOSS_DATA=. cutgextract -auto -directory ${S} || die \
			"Indexing CUTG failed."
	fi
}

src_install() {
	if ! use no-rawdb; then
		insinto /usr/share/${PN}
		doins *.codon *.spsum
	fi
	dodoc README
	if [ -e /usr/bin/cutgextract ] && ! use no-emboss; then
		insinto /usr/share/EMBOSS/data/CODONS
		cd CODONS
		for file in *; do
			doins ${file}
		done
	fi
}
