# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/youtube-dl/youtube-dl-2008.07.26.ebuild,v 1.1 2008/07/29 11:42:05 yngwin Exp $

DESCRIPTION="A small command-line program to download videos from YouTube."
HOMEPAGE="http://www.arrakis.es/~rggi3/youtube-dl/"
SRC_URI="http://www.arrakis.es/~rggi3/${PN}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}/${P}" ${PN}
}
