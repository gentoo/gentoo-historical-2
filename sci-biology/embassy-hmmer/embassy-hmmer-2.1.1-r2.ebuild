# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-hmmer/embassy-hmmer-2.1.1-r2.ebuild,v 1.7 2006/11/02 22:26:31 grobian Exp $

EBOV="3.0.0"

inherit embassy

DESCRIPTION="EMBOSS integrated version of HMMER - Biological sequence analysis with profile HMMs"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/old/${EBOV}/EMBOSS-${EBOV}.tar.gz
	ftp://emboss.open-bio.org/pub/EMBOSS/old/${EBOV}/${EF}.tar.gz"

RESTRICT="mirror"

KEYWORDS="ppc x86"

src_install() {
	embassy_src_install
	insinto /usr/include/emboss/hmmer
	doins src/*.h
}
