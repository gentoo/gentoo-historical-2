# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/read-edid/read-edid-1.4.1.ebuild,v 1.8 2003/03/01 01:10:33 vapier Exp $

DESCRIPTION="program that can get information from a pnp monitor."
HOMEPAGE="http://john.fremlin.de/programs/linux/read-edid/index.html"
SRC_URI="http://john.fremlin.de/programs/linux/read-edid/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog LRMI NEWS README
}
