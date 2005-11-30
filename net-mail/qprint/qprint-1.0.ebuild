# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qprint/qprint-1.0.ebuild,v 1.1.1.1 2005/11/30 10:03:12 chriswhite Exp $

DESCRIPTION="MIME quoted-printable data encoding and decoding utility"
HOMEPAGE="http://www.fourmilab.ch/webtools/qprint/"
SRC_URI="http://www.fourmilab.ch/webtools/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	make DESTDIR=${D} install || die "make install failed"
	dodoc COPYING INSTALL README *.html qprint.pdf qprint.w logo.gif
}
