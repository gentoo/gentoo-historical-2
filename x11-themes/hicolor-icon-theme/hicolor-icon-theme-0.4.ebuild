# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/hicolor-icon-theme/hicolor-icon-theme-0.4.ebuild,v 1.4 2004/03/24 21:11:03 jhuebel Exp $

DESCRIPTION="Fallback theme for freedesktop icon theme specification"
HOMEPAGE="http://freedesktop.org/Software/icon-theme"
LICENSE=""

SRC_URI="http://freedesktop.org/Software/icon-theme/releases/${P}.tar.gz"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
SLOT="0"

DEPEND=""

src_compile() {

	econf --prefix=${D}/usr || die

}

src_install() {

	make DESTDIR=${D} PREFIX=${D}/usr install || die

	dodoc README ChangeLog

}
