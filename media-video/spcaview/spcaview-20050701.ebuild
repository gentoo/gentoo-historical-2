# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/spcaview/spcaview-20050701.ebuild,v 1.2 2005/09/05 19:35:04 kingtaco Exp $

inherit eutils

DESCRIPTION="A webcam viewer for the spca5xx driver."
HOMEPAGE="http://mxhaard.free.fr/sview.html"
SRC_URI="http://mxhaard.free.fr/spca50x/Download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="media-libs/libsdl"
RDEPEND="media-video/spca5xx"
S=${WORKDIR}/${P}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodir usr/bin
	make BIN=${D}/usr/bin install || die
	dodoc README Changelog
}
