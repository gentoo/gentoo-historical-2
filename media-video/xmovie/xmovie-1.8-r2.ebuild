# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/xmovie/xmovie-1.8-r2.ebuild,v 1.2 2002/04/12 17:02:14 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A Player for MPEG and Quicktime movies"
SRC_URI="http://heroinewarrior.com/${P}.tar.gz"
HOMEPAGE="http://heroines.sourceforge.net/"

RDEPEND="virtual/glibc
	virtual/x11
	>=sys-devel/gcc-2.95.2
	=dev-libs/glib-1.2*
	>=media-libs/libpng-1.0.7"

DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98"

src_compile() {
	local myconf
	use mmx || myconf="${myconf} --no-mmx"
    
	./configure ${myconf} || die
	emake || die

}

src_install () {

    into /usr
    dobin xmovie/`uname -m`/xmovie
    dodoc README
    dohtml docs/*.html

}



