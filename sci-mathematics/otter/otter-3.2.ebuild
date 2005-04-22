# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/otter/otter-3.2.ebuild,v 1.2 2005/04/22 00:06:28 wormo Exp $

DESCRIPTION="An Automated Deduction System."
SRC_URI="http://www-unix.mcs.anl.gov/AR/${PN}/${P}.tar.gz"
HOMEPAGE="http://www-unix.mcs.anl.gov/AR/otter/"

KEYWORDS="x86"
LICENSE="otter"
SLOT="0"
IUSE=""
DEPEND="virtual/libc"
S=${WORKDIR}/${P}/source
WORK=${WORKDIR}/${P}


src_compile() {
	cd ${S}
	emake || die
	cd ${S}/mace
	emake || die
}

src_install() {
	cd ${S}
	dobin otter mace/mace formed/formed
	cd ${WORK}
	dodoc README Legal Copying Changelog documents/*
}

