# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/mlterm/mlterm-2.5.0.ebuild,v 1.1 2002/08/22 15:57:55 stubear Exp $

DESCRIPTION="A multi-lingual terminal emulator"

HOMEPAGE="http://mlterm.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"

SLOT="0"

KEYWORDS="x86"

DEPEND="virtual/glibc
	>=x11-base/xfree-4.2.0
	imlib?    ( >=media-libs/imlib-1.9.14 )
	gtk?      ( >=x11-libs/gtk+-1.2.10 )
	gnome?    ( >=media-libs/gdk-pixbuf-0.18.0 )
	truetype? ( >=media-libs/freetype-2.1.2 )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P}

src_compile() {
	local myconf

	use imlib \
		&& myconf="${myconf} --enable-imlib"

	use gnome \
		&& myconf="${myconf} --enable-gdk-pixbuf"

	use truetype \
		&& myconf="${myconf} --enable-anti-alias"

	myconf="${myconf} --enable-utmp"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} || die "./configure failed"

	emake || die
}

src_install () {

	make DESTDIR=${D} install || die

	dodoc ChangeLog LICENCE README
}
