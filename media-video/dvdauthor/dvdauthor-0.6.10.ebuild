# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdauthor/dvdauthor-0.6.10.ebuild,v 1.1 2004/05/16 14:59:22 mholzer Exp $

DESCRIPTION="Tools for generating DVD files to be played on standalone DVD players"
HOMEPAGE="http://sourceforge.net/projects/dvdauthor/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE="png zlib"

DEPEND="media-libs/libdvdread
	>=media-gfx/imagemagick-5.5.7.14
	>=dev-libs/libxml2-2.5.0"

src_compile() {
	econf || die "configuration failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "installation failed"
	dodoc README HISTORY TODO
}
