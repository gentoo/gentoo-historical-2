# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/prosite/prosite-19.3.ebuild,v 1.2 2005/06/26 16:27:17 ribosome Exp $

DESCRIPTION="A protein families and domains database"
HOMEPAGE="http://ca.expasy.org/prosite"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="swiss-prot"
SLOT="0"
KEYWORDS="x86 ~ppc ~ppc-macos ~ppc64"
IUSE="emboss minimal"
# Minimal build keeps only the indexed files (if applicable) and the documentation.
# The non-indexed database is not installed.

DEPEND="emboss? ( sci-biology/emboss )"

src_compile() {
	if use emboss; then
		mkdir PROSITE
		echo
		einfo "Indexing PROSITE for usage with EMBOSS."
		EMBOSS_DATA="." prosextract -auto -infdat ${S} || die \
			"Indexing PROSITE failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins ${PN}.{doc,dat,lis}
	fi
	dodoc *.txt
	dohtml *.htm
	if use emboss; then
		insinto /usr/share/EMBOSS/data/PROSITE
		doins PROSITE/*
	fi
}
