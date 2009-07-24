# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shoutcast-search/shoutcast-search-0.3.ebuild,v 1.1 2009/07/24 19:52:30 ssuominen Exp $

inherit distutils

DESCRIPTION="A command-line tool for searching SHOUTcast stations"
HOMEPAGE="http://www.k2h.se/code/shoutcast-search.html"
SRC_URI="http://www.k2h.se/code/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4"
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_install() {
	distutils_src_install
	dobin ${PN} || die "dobin failed"
	doman ${PN}.1 || die "doman failed"
	dodoc documentation.md || die "dodoc failed"
}
