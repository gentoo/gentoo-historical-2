# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/hicolor-icon-theme/hicolor-icon-theme-0.5.ebuild,v 1.9 2004/09/16 20:36:36 gustavoz Exp $

DESCRIPTION="Fallback theme for the freedesktop icon theme specification"
HOMEPAGE="http://freedesktop.org/Software/icon-theme"
SRC_URI="http://freedesktop.org/Software/icon-theme/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha arm ~hppa amd64 ia64 ppc64"
IUSE=""

DEPEND=""

src_install() {

	make DESTDIR=${D} install || die
	dodoc README ChangeLog

}
