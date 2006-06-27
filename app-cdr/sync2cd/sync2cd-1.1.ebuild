# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/sync2cd/sync2cd-1.1.ebuild,v 1.1 2006/06/27 15:26:08 lisa Exp $

inherit distutils

DESCRIPTION="An incremental archiving tool to CD/DVD."
HOMEPAGE="http://www.calins.ch/software/sync2cd.html"
SRC_URI="http://www.calins.ch/download/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="cdr dvdr"

RDEPEND="sys-apps/eject
		cdr? ( app-cdr/cdrtools )
		dvdr? ( app-cdr/dvd+rw-tools )"

src_test() {
	cd ${S}/tests
	./run.py || die "Unit tests failed"
}
