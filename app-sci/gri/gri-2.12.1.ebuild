# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/gri/gri-2.12.1.ebuild,v 1.1 2002/12/07 04:21:59 george Exp $

IUSE=""

S="${WORKDIR}/${P}"
DESCRIPTION="Gri is a language for scientific graphics programming."
HOMEPAGE="http://gri.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=app-sci/netcdf-3.5.0"


src_compile() {
	econf
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHOR README
	#move docs to the proper place
	mv ${D}/usr/share/gri/doc/* ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/share/gri/doc/
}
