# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/man-pages/man-pages-1.56.ebuild,v 1.4 2003/09/18 00:13:25 avenj Exp $

MY_PN=${PN/-/}
S=${WORKDIR}/${P}
DESCRIPTION="A somewhat comprehensive collection of Linux man pages"
SRC_URI="mirror://kernel/linux/docs/${MY_PN}/${P}.tar.bz2"
HOMEPAGE="http://www.win.tue.nl/~aeb/linux/man/"
KEYWORDS="x86 amd64 ppc sparc alpha mips hppa arm ia64"
RDEPEND="sys-apps/man"
LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	tar xzf ${FILESDIR}/man2.tar.gz
}

src_install() {
	einstall MANDIR=${D}/usr/share/man || die
	dodoc man-pages-*.Announce README
}
