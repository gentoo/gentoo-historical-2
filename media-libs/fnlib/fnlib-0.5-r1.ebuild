# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fnlib/fnlib-0.5-r1.ebuild,v 1.21 2004/01/08 03:10:53 agriffis Exp $

inherit gnuconfig

DESCRIPTION="Font Library"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"

DEPEND="virtual/glibc
	media-libs/imlib"

src_compile() {
	gnuconfig_update

	econf --sysconfdir=/etc/fnlib || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog COPYING* HACKING NEWS README
	dodoc doc/fontinfo.README
}
