# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdauthor/dvdauthor-0.6.10.ebuild,v 1.12 2005/02/04 19:00:40 luckyduck Exp $

inherit eutils 64-bit

DESCRIPTION="Tools for generating DVD files to be played on standalone DVD players"
HOMEPAGE="http://dvdauthor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc amd64 ~ppc64"
IUSE=""

DEPEND="media-libs/libdvdread
	>=media-gfx/imagemagick-5.5.7.14
	>=dev-libs/libxml2-2.5.0
	media-libs/libpng"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gcc34.patch
	64-bit && epatch ${FILESDIR}/${P}-utf8.patch
	epatch ${FILESDIR}/${P}-im6.patch

	# see #62836
	epatch ${FILESDIR}/${P}-debugsegfault.patch
}

src_install() {
	make install DESTDIR=${D} || die "installation failed"
	dodoc README HISTORY TODO
}
