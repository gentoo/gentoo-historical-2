# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/abs-guide/abs-guide-3.2.ebuild,v 1.1 2005/02/11 15:43:18 ka0ttic Exp $

DESCRIPTION="An advanced reference and a tutorial on bash shell scripting"
SRC_URI="http://personal.riverusers.com/~thegrendel/${P}.tar.bz2"
HOMEPAGE="http://www.tldp.org/LDP/abs/html"
S="${WORKDIR}"

IUSE=""
KEYWORDS="x86 sparc ppc alpha hppa amd64"
LICENSE="FDL-1.1"
SLOT="0"

src_install() {
	dodir /usr/share/doc/${P}       || die "dodir failed"
	cp -R * ${D}/usr/share/doc/${P} || die "cp failed"
}
