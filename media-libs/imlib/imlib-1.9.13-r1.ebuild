# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/imlib/imlib-1.9.13-r1.ebuild,v 1.3 2002/04/03 00:29:39 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Imlib is a general Image loading and rendering library."
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz
	 http://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz
	 ftp://gnome.eazel.com/pub/gnome/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

DEPEND="virtual/glibc
	>=media-libs/giflib-4.1.0
	>=media-libs/libpng-1.0.7
	>=media-libs/tiff-3.5.5
	>=media-libs/libungif-4.1.0
	>=sys-libs/zlib-1.1.3-r2
	>=x11-libs/gtk+-1.2.10-r4
	virtual/x11"

src_compile() {
	
	#update libtool to fix "relink" bug
	libtoolize --copy --force

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc/imlib || die
		
	emake || die
}

src_install() {

	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc/imlib \
		install || die

	preplib /usr

	dodoc AUTHORS COPYING* ChangeLog README
	dodoc NEWS
	dohtml doc/*.gif doc/index.html
}

