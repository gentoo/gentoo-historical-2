# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/open-cobol/open-cobol-0.23.ebuild,v 1.3 2004/04/26 00:11:58 agriffis Exp $

DESCRIPTION="an open-source COBOL compiler"
HOMEPAGE="http://www.open-cobol.org/"
SRC_URI="mirror://sourceforge/open-cobol/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls readline ncurses"

DEPEND="sys-devel/libtool
	>=dev-libs/gmp-3.1.1
	>=sys-libs/db-2.0
	readline? ( sys-libs/readline )
	ncurses? ( >=sys-libs/ncurses-5.2 )"

src_compile() {

	econf \
		$(use_enable nls) \
		$(use_with readline) || die "econf failed"
	emake
}

src_install() {

	einstall
	dodoc ABOUT-NLS AUTHORS ChangeLog INSTALL NEWS README
}
