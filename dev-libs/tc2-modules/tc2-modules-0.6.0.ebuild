# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tc2-modules/tc2-modules-0.6.0.ebuild,v 1.5 2005/12/16 12:03:28 flameeyes Exp $

IUSE="static"

DESCRIPTION="Modules for dev-libs/tc2."
HOMEPAGE="http://tc2.sourceforge.net"
SRC_URI="mirror://sourceforge/tc2/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~ia64 ~amd64"


RDEPEND=">=dev-libs/tc2-0.6.0"


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
