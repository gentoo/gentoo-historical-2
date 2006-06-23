# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pinfo/pinfo-0.6.9.ebuild,v 1.1 2006/06/23 12:46:43 jer Exp $

inherit eutils

DESCRIPTION="Hypertext info and man viewer based on (n)curses"
HOMEPAGE="http:/pinfo.alioth.debian.org"
SRC_URI="https://alioth.debian.org/download.php/1498/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls readline"

RDEPEND="sys-libs/ncurses
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	sys-devel/bison
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-FTPVIEWER.patch
}

src_compile() {
	econf \
		$(use_with readline) \
		$(use_enable nls) \
		|| die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} sysconfdir=/etc install || die
}
