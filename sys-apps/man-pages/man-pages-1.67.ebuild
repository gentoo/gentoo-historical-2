# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/man-pages/man-pages-1.67.ebuild,v 1.2 2004/05/23 23:23:19 vapier Exp $

DESCRIPTION="A somewhat comprehensive collection of Linux man pages"
HOMEPAGE="http://www.win.tue.nl/~aeb/linux/man/"
SRC_URI="mirror://kernel/linux/docs/manpages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 ppc64 s390"
IUSE=""

RDEPEND="sys-apps/man"

src_install() {
	einstall MANDIR=${D}/usr/share/man || die
	dodoc man-pages-*.Announce README
}
