# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/hicolor-icon-theme/hicolor-icon-theme-0.5.ebuild,v 1.2 2004/06/01 21:47:18 lv Exp $

DESCRIPTION="Fallback theme for the freedesktop icon theme specification"
HOMEPAGE="http://freedesktop.org/Software/icon-theme"
SRC_URI="http://freedesktop.org/Software/icon-theme/releases/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~mips ~hppa amd64 ~ia64"
IUSE=""

DEPEND=""

src_compile() {

	econf || die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die
	dodoc README ChangeLog

}
