# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/lphdisk/lphdisk-0.9.1.ebuild,v 1.2 2004/06/24 21:58:35 agriffis Exp $

DESCRIPTION="utility for preparing a hibernation partition for APM Suspend-To-Disk"
HOMEPAGE="http://www.procyon.com/~pda/lphdisk/"
SRC_URI="http://www.procyon.com/~pda/lphdisk/${P}.tar.bz2"

# <chadh@gentoo.org>  I haven't actually tested that this doesn't work
# on all the below - arches, but it won't work.  This only works on x86
# laptops with Phoenix NoteBIOS.

SLOT="0"
IUSE=""
KEYWORDS="x86 -ppc -sparc -alpha"
LICENSE="Artistic"

src_compile() {
	sed -i -e "s:/usr/local:usr:" \
		-e "s:-g -Wall:${CFLAGS}:" \
		Makefile
	make || die
}

src_install() {
	dosbin lphdisk
	doman lphdisk.8
}
