# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libogg/libogg-1.0_rc3-r1.ebuild,v 1.8 2003/09/06 23:59:48 msterret Exp $

S=${WORKDIR}/libogg-1.0rc3
DESCRIPTION="the Ogg media file format library"
SRC_URI="http://www.vorbis.com/files/rc3/unix/${PN}-1.0rc3.tar.gz"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc "

src_compile() {
	./configure --prefix=/usr --host=${CHOST} || die

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	# remove the docs installed by make install, since I'll install
	# them in portage package doc directory
	echo "Removing docs installed by make install"
	rm -rf ${D}/usr/share/doc

	dodoc AUTHORS CHANGES COPYING README
	dohtml doc/*.{html,png}
}

