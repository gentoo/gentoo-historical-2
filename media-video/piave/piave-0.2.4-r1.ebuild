# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/piave/piave-0.2.4-r1.ebuild,v 1.5 2004/10/26 22:01:45 malc Exp $

inherit eutils gcc

DESCRIPTION="PIAVE - Piave Is A Video Editor"
HOMEPAGE="http://modesto.sourceforge.net/piave/index.html"
SRC_URI="mirror://sourceforge/modesto/${P}.tar.gz"

IUSE="nls"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

DEPEND="virtual/x11
	>=dev-util/pkgconfig-0.15.0
	>=dev-libs/libxml2-2.5.11
	>=dev-cpp/libxmlpp-0.21.0
	>=media-libs/gdk-pixbuf-0.22.0
	>=media-libs/libsdl-1.2.6-r2
	>=media-libs/sdl-image-1.2.3
	>=media-libs/libdv-0.99-r1
	>=media-libs/libsndfile-1.0.5
	>=media-libs/libvorbis-1.0.1
	>=sys-libs/libraw1394-0.9.0
	>=sys-libs/libavc1394-0.4.1"


src_compile() {
	cd ${S}
	epatch ${FILESDIR}/piave-0.2.4-include-arts.diff
	if [ "`gcc-minor-version`" -eq "4" ]
	then
	epatch ${FILESDIR}/piave-0.2.4-gcc34.patch
	fi
	myconf=${myconf}" --with-gnu-ld	`use_enable nls`"
	econf ${myconf} || die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README TODO
}
