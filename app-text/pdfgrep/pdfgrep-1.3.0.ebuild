# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdfgrep/pdfgrep-1.3.0.ebuild,v 1.3 2012/02/21 12:06:02 ssuominen Exp $

EAPI=4

DESCRIPTION="A tool similar to grep which searches text in PDFs"
HOMEPAGE="http://pdfgrep.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="unac"

RDEPEND="app-text/poppler[cxx]
	unac? ( app-text/unac )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf $(use_with unac)
}
