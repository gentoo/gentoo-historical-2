# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/seahorse/seahorse-0.5.0.ebuild,v 1.22 2004/04/26 15:52:36 agriffis Exp $

DESCRIPTION="gnome front end to gnupg"
SRC_URI="mirror://sourceforge/seahorse/${P}.tar.gz"
HOMEPAGE="http://seahorse.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"

DEPEND="virtual/x11
	>=app-crypt/gnupg-1.0.4
	>=gnome-base/gnome-libs-1.4.1.2-r1"

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} \
	     localedir=${D}/usr/share/locale \
	     gnulocaledir=${D}/usr/share/locale install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
