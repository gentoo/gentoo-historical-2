# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fbset/fbset-2.1.ebuild,v 1.18 2003/06/21 21:19:39 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A utility to set the framebuffer videomode"
SRC_URI="http://home.tvd.be/cr26864/Linux/fbdev/${P}.tar.gz"
HOMEPAGE="http://linux-fbdev.org"
KEYWORDS="x86 amd64 ppc sparc alpha hppa"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {
	make || die
}

src_install() {
	dobin fbset modeline2fb
	doman *.[58]
	dodoc etc/fb.modes.*
	dodoc INSTALL
}
