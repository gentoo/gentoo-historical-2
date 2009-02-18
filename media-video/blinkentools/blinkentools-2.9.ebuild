# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/blinkentools/blinkentools-2.9.ebuild,v 1.5 2009/02/18 18:56:17 beandog Exp $

DESCRIPTION="blinkentools is a set of commandline utilities related to Blinkenlights."
HOMEPAGE="http://www.blinkenlights.net/project/developer-tools"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="media-libs/blib
	media-libs/libmng"
RDEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" \
		install || die "install failed"
}
