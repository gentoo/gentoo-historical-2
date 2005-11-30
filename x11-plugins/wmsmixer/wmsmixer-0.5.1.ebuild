# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmsmixer/wmsmixer-0.5.1.ebuild,v 1.1 2004/06/30 08:25:32 s4t4n Exp $

inherit eutils
IUSE=""
DESCRIPTION="fork of wmmixer adding scrollwheel support and other features"
HOMEPAGE="http://www.hibernaculum.net/wmsmixer.html"
SRC_URI="http://www.hibernaculum.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc"

DEPEND="virtual/libc
	virtual/x11"

src_compile() {
	g++ -m32 ${CFLAGS} -I/usr/X11R6/include -c -o wmsmixer.o wmsmixer.cc
	rm -f wmsmixer
	g++ -o wmsmixer ${CFLAGS} -L/usr/X11R6/lib wmsmixer.o -lXpm -lXext -lX11
}

src_install() {
	insinto /usr/bin
	insopts -m0655
	doins wmsmixer
	dodoc README README.wmmixer
}
