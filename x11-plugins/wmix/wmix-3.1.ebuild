# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmix/wmix-3.1.ebuild,v 1.2 2004/07/06 16:27:55 s4t4n Exp $

IUSE=""
DESCRIPTION="Dockapp mixer for OSS or ALSA"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.gz"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~amd64 ~ppc"

DEPEND="virtual/x11
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A} ; cd ${S}
	sed -i -e "/^CFLAGS/d" Makefile
}

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/bin
	doexe wmix
	gzip -cd wmix.1x.gz > wmix.1
	doman wmix.1
	dodoc README COPYING INSTALL NEWS BUGS AUTHORS sample.wmixrc
}
