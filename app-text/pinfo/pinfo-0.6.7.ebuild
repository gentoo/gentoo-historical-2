# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pinfo/pinfo-0.6.7.ebuild,v 1.9 2005/12/04 21:11:43 jer Exp $

DESCRIPTION="Hypertext info and man viewer based on (n)curses"
HOMEPAGE="http://dione.ids.pl/~pborys/software/linux/"
SRC_URI="http://dione.ids.pl/~pborys/software/pinfo/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc sparc"
IUSE="nls readline"

DEPEND="sys-libs/ncurses
	sys-devel/bison
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use readline \
		&& myconf="${myconf} --with-readline" \
		|| myconf="${myconf} --without-readline"

	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	econf ${myconf} || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} sysconfdir=/etc install || die
}
