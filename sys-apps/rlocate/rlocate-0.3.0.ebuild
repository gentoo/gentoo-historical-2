# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/rlocate/rlocate-0.3.0.ebuild,v 1.1 2005/05/27 22:56:33 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="locate implementation that is always up-to-date"
HOMEPAGE="http://rlocate.sourceforge.net/"
SRC_URI="mirror://sourceforge/rlocate/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/kernel"
RDEPEND="!sys-apps/slocate"

src_compile() {
	econf --enable-sandboxed || die
	ARCH=$(tc-arch-kernel) emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog* NEWS README
}
