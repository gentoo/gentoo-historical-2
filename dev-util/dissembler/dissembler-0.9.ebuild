# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/dissembler/dissembler-0.9.ebuild,v 1.2 2005/05/07 11:01:14 dholm Exp $

MY_P=${PN}_${PV}
DESCRIPTION="polymorphs bytecode to a printable ASCII string"
HOMEPAGE="http://www.phiral.com/research/dissembler.html"
SRC_URI="http://www.phiral.com/research/${MY_P}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	make ${PN} || die
}

src_install() {
	dobin ${PN} || die
	dodoc ${PN}.txt
}
