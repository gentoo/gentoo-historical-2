# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/ivritex/ivritex-1.1.1.ebuild,v 1.5 2004/04/13 13:46:09 kugelfang Exp $

S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/ivritex/${P}.tar.gz"
HOMEPAGE="http://ivritex.sourceforge.net/"
SLOT="0"
LICENSE="LPPL-1.2"
DESCRIPTION="Hebrew support for TeX"
DEPEND=">=app-text/tetex-2.0.0"
KEYWORDS="x86 ~amd64"

src_install () {

	make TEX_ROOT=${D}/usr/share/texmf install || die

}

pkg_postinst() {

	einfo "Running texhash to complete installation.."
	addwrite "/var/lib/texmf"
	addwrite "/usr/share/texmf"
	addwrite "/var/cache/fonts"
	texhash
}
