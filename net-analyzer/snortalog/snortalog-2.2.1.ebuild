# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snortalog/snortalog-2.2.1.ebuild,v 1.3 2004/07/08 22:56:22 eldad Exp $

DESCRIPTION="a powerfull perl script that summarizes snort logs"
SRC_URI="http://jeremy.chartier.free.fr/${PN}/${PN}_v${PV}.tgz"
HOMEPAGE="http://jeremy.chartier.free.fr/snortalog/"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

S=${WORKDIR}/${PN}_v${PV%.?}

RDEPEND="dev-lang/perl"

src_compile() {
	einfo "Nothing to compile."
}

src_install () {

	dodir /usr/bin
	mv ${S}/snortalog.pl ${D}/usr/bin

	dodoc CHANGES README domains hw rules snortalog_v2.2.0.pdf
}
