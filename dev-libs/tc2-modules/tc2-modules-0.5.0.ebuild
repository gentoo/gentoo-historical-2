# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tc2-modules/tc2-modules-0.5.0.ebuild,v 1.2 2004/02/22 20:13:30 agriffis Exp $

IUSE="static"

S=${WORKDIR}/${P}
DESCRIPTION="Modules for tc2."
HOMEPAGE="http://tc2.sourceforge.net"
SRC_URI="mirror://sourceforge/tc2/${P}.tar.gz"

SLOT="0"
LICENSE="OpenSoftware"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~amd64 ~ia64"

DEPEND=">=dev-libs/tc2-0.5.0"


src_compile() {
	local myconf
	myconf="--with-gnu-ld"
	use static && myconf="${myconf} --enable-static"

	econf ${myconf} || die "configure failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
