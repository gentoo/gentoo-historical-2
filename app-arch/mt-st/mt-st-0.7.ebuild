# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/mt-st/mt-st-0.7.ebuild,v 1.19 2005/01/01 11:49:13 eradicator Exp $

DESCRIPTION="Enhanced mt command for Linux, supporting Linux 2.4 ioctls"
HOMEPAGE="http://www.gnu.org/software/tar/"
SRC_URI="http://www.ibiblio.org/pub/linux/system/backup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:-O2:${CFLAGS}:g" Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dosbin mt stinit || die
	doman mt.1 stinit.8
}
