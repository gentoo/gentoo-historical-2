# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cfv/cfv-1.18.3.ebuild,v 1.1 2009/09/01 08:12:35 patrick Exp $

DESCRIPTION="Utility to test and create .sfv, .csv, .crc and md5sum files"
HOMEPAGE="http://cfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/cfv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"

DEPEND=""
RDEPEND="dev-lang/python
	dev-python/python-fchksum"

src_compile() {
	true
}

src_install() {
	dobin cfv || die "dobin failed"
	doman cfv.1 || die "doman failed"
	dodoc README Changelog || die "dodoc failed"
}
