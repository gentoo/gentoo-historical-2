# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/SphinxTrain/SphinxTrain-0.9.1-r1.ebuild,v 1.1 2004/03/17 04:10:20 eradicator Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="SphinxTrain - Speech Recognition (Training Module)"
HOMEPAGE="http://www.speech.cs.cmu.edu/SphinxTrain/"
SRC_URI="http://www.speech.cs.cmu.edu/${PN}/${P}-beta.tar.gz"
SLOT="0"
LICENSE="BSD as-is"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/glibc
	app-accessibility/sphinx2
	app-accessibility/festival"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/gcc.patch
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	dodoc etc/*cfg
	dobin bin.*/*
	dodoc README
	dohtml doc/*[txt html sgml]
}

pkg_postinst() {
	einfo
	einfo "Detailed usage and training instructions can be found at"
	einfo "http://www.speech.cs.cmu.edu/SphinxTrain/"
	einfo
}
