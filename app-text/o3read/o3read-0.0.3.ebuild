# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/o3read/o3read-0.0.3.ebuild,v 1.3 2003/02/13 09:42:37 vapier Exp $

DESCRIPTION="Converts OpenOffice formats to text or HTML."
HOMEPAGE="http://siag.nu/o3read/"
SRC_URI="http://siag.nu/pub/o3read/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="app-arch/unzip"

src_compile() {
	emake || die
}

src_install() {
	dobin o3read o3totxt o3tohtml utf8tolatin1
	doman o3read.1 o3tohtml.1 o3totxt.1 utf8tolatin1.1
}
