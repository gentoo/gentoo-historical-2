# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/cbind/cbind-6.ebuild,v 1.7 2004/06/24 21:46:10 agriffis Exp $

inherit eutils

S="${WORKDIR}/${PN}${PV}"
DESCRIPTION="This tool is designed to aid in the creation of Ada bindings to C."
SRC_URI="http://unicoi.kennesaw.edu/ase/ase02_02/tools/cbind/${PN}${PV}.zip"
HOMEPAGE="http://www.rational.com/"
LICENSE="GMGPL"

DEPEND="dev-lang/gnat"

SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A} ; cd ${S}
	epatch ${FILESDIR}/${PN}${PV}.diff
}

src_compile() {
	make || die
}

src_install () {
	make PREFIX=${D}/usr/ install || die

	# Install documentation.
	dodoc README
}
