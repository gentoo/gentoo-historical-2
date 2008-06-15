# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/extract-xiso/extract-xiso-2.5.ebuild,v 1.3 2008/06/15 11:39:09 drac Exp $

inherit eutils

MY_PV=${PV/_beta/b}

DESCRIPTION="Tool for extracting and creating optimised Xbox ISO images"
HOMEPAGE="http://sourceforge.net/projects/extract-xiso"
SRC_URI="mirror://sourceforge/extract-xiso/${PN}_v${MY_PV}_src.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	sed -i -e "s:-O2:${CFLAGS}:g" "${S}"/Makefile || die "sed failed."
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	dobin extract-xiso || die "dobin failed."
}
