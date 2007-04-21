# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/prosite/prosite-20.10.ebuild,v 1.1 2007/04/21 03:20:06 ribosome Exp $

DESCRIPTION="A protein families and domains database"
LICENSE="swiss-prot"
HOMEPAGE="http://ca.expasy.org/prosite"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="emboss? ( >=sci-biology/emboss-3.0.0 )"

src_compile() {
	if use emboss; then
		mkdir PROSITE
		echo
		einfo "Indexing PROSITE for usage with EMBOSS."
		EMBOSS_DATA="." prosextract -auto -prositedir "${S}" || die \
			"Indexing PROSITE failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins *.{doc,dat,lis} || die "Installing raw database failed."
	fi
	dodoc *.txt || die "Documentation installation failed."
	dohtml *.htm || die "HTML documentation installation failed."
	insinto /usr/share/doc/${PF}
	doins *.pdf || die "PDF documentation installation failed."
	if use emboss; then
		insinto /usr/share/EMBOSS/data/PROSITE
		doins PROSITE/* || die "Installing EMBOSS data files failed."
	fi
}
