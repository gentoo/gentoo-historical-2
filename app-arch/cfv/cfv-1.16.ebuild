# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cfv/cfv-1.16.ebuild,v 1.6 2004/06/24 21:28:50 agriffis Exp $

DESCRIPTION="Utility to test and create .sfv, .csv, .crc and md5sum files"
HOMEPAGE="http://cfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/cfv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86 ~ppc amd64"

DEPEND=""
RDEPEND="dev-lang/python
	dev-python/python-fchksum"

src_install() {
	dobin cfv
	doman cfv.1
	dodoc README Changelog
}
