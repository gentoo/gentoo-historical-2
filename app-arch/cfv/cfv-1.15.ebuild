# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cfv/cfv-1.15.ebuild,v 1.1 2003/10/09 14:54:34 vapier Exp $

DESCRIPTION="Utility to test and create .sfv, .csv, .crc and md5sum files"
HOMEPAGE="http://cfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/cfv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND=""
RDEPEND="dev-lang/python
	dev-python/python-fchksum"

src_install() {
	dobin cfv
	doman cfv.1
	dodoc README Changelog
}
