# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dnotify/dnotify-0.5.0.ebuild,v 1.17 2004/09/18 17:26:00 swegener Exp $

DESCRIPTION="Execute a command when the contents of a directory change"
SRC_URI="mirror://gentoo/dnotify-${PV}.tar.gz"
HOMEPAGE="http://www.student.lu.se/~nbi98oli/dnotify.html"
KEYWORDS="x86 amd64 ppc sparc mips"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

src_compile() {
	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--sysconfdir=/etc
	make || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		install || die
	dodoc AUTHORS ChangeLog COPYING* NEWS README
}
