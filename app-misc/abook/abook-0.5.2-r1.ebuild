# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/abook/abook-0.5.2-r1.ebuild,v 1.6 2004/06/24 22:01:20 agriffis Exp $

inherit eutils

DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client."
HOMEPAGE="http://abook.sourceforge.net/"
SRC_URI="mirror://sourceforge/abook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc"
IUSE=""

DEPEND="sys-libs/ncurses
	sys-libs/readline"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/abook-0.5.2-filter.diff
}

src_install() {
	make install DESTDIR=${D} || die "install died"
	dodoc ANNOUNCE AUTHORS BUGS ChangeLog FAQ INSTALL NEWS README THANKS TODO
	dodoc sample.abookrc
}
