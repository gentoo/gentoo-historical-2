# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsnap/xsnap-1.4.3-r1.ebuild,v 1.7 2005/11/01 19:39:48 dertobi123 Exp $

inherit eutils

DESCRIPTION="Program to interactively take a 'snapshot' of a region of the screen"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/Xutils/${P}.tar.bz2"
HOMEPAGE="ftp://ftp.ac-grenoble.fr/ge/Xutils/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.4-gentoo.patch
	# i notified upstream about it... should be fixed soon
	epatch ${FILESDIR}/${PN}-this-should-be-fixed-updstream.patch
}

src_compile() {
	xmkmf || die "xmkmf failed"
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	make DESTDIR=${D} install.man || die "make install.man failed"
	dodoc README AUTHORS
}
