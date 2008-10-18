# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/o3read/o3read-0.0.4.ebuild,v 1.7 2008/10/18 15:06:48 nixnut Exp $

DESCRIPTION="Converts OpenOffice formats to text or HTML."
HOMEPAGE="http://siag.nu/o3read/"
SRC_URI="http://siag.nu/pub/o3read/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="app-arch/unzip"

src_compile() {
	emake || die
}

src_install() {
	dobin o3read o3totxt o3tohtml utf8tolatin1
	doman o3read.1 o3tohtml.1 o3totxt.1 utf8tolatin1.1
}
