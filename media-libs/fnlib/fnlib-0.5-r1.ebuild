# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fnlib/fnlib-0.5-r1.ebuild,v 1.12 2003/02/21 23:00:10 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Font Library"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="ftp://ftp.enlightenment.org/pub/enlightenment/enlightenment/libs/${P}.tar.gz"

DEPEND="virtual/glibc
	>=media-libs/imlib-1.9.8.1"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha"

src_compile() {

	econf --sysconfdir=/etc/fnlib || die
	make || die
}

src_install() {
	
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog COPYING* HACKING NEWS README
	dodoc doc/fontinfo.README

}
