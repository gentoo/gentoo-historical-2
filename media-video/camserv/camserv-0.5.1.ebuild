# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/camserv/camserv-0.5.1.ebuild,v 1.3 2003/10/12 16:37:30 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A streaming video server."
SRC_URI="mirror://sourceforge/cserv/${P}.tar.gz"
HOMEPAGE="http://cserv.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=media-libs/jpeg-6b-r2
	>=media-libs/imlib-1.9.13-r2"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-0.5-errno.patch
}

src_compile() {

	econf || die
	emake || die

}

src_install () {

	einstall datadir=${D}/usr/share/${PN} || die

	dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO javascript.txt
	dohtml defpage.html

}
