# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fnlib/fnlib-0.5-r1.ebuild,v 1.17 2003/11/05 21:01:48 vapier Exp $

DESCRIPTION="Font Library"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="virtual/glibc
	media-libs/imlib"

src_compile() {
	econf --sysconfdir=/etc/fnlib || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog COPYING* HACKING NEWS README
	dodoc doc/fontinfo.README
}
