# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtc/libtc-1.1.0.ebuild,v 1.7 2005/12/16 12:01:27 flameeyes Exp $

IUSE="static"

DESCRIPTION="libtc is a library of useful functions and function often missing on some systems -- supplements libc functions."
HOMEPAGE="http://libtc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT X11"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~ia64 ~amd64"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}"

src_compile() {
	local myconf
	use static && myconf="${myconf} --enable-static"
	econf ${myconf} || die "configure failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING
}
