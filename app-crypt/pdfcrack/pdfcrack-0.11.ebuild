# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pdfcrack/pdfcrack-0.11.ebuild,v 1.1 2008/08/16 01:14:38 vapier Exp $

inherit eutils

DESCRIPTION="Tool for recovering passwords and content from PDF-files"
HOMEPAGE="http://pdfcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.10-build.patch
}

src_install() {
	dobin pdfcrack || die
	dodoc changelog README TODO
}
