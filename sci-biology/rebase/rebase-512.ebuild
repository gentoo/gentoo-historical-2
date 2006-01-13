# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/rebase/rebase-512.ebuild,v 1.2 2006/01/13 02:50:09 ribosome Exp $

DESCRIPTION="A restriction enzyme database"
LICENSE="public-domain"
HOMEPAGE="http://rebase.neb.com"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="x86 ~ppc ~amd64 ~ppc-macos ~ppc64"

DEPEND="emboss? ( sci-biology/emboss )"

src_compile() {
	if use emboss; then
		echo
		einfo "Indexing ${PN} for usage with EMBOSS."
		mkdir REBASE
		EMBOSS_DATA=. rebaseextract -auto -infile withrefm.${PV} \
			-protofile proto.${PV} || die "Indexing ${PN} failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins withrefm.${PV} proto.${PV} || die \
			"Failed to install raw database."
	fi
	newdoc REBASE.DOC README || die "Failed to install documentation."
	if use emboss; then
		insinto /usr/share/EMBOSS/data/REBASE
		doins REBASE/{embossre.enz,embossre.ref,embossre.sup} || die \
			"Failed to install EMBOSS data files."
	fi
}
