# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gtkesms/gtkesms-0.0.4.ebuild,v 1.12 2004/04/26 18:53:28 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="gtk gui for esms."
SRC_URI="mirror://sourceforge/esms/${P}.tar.gz"
HOMEPAGE="http://esms.sourceforge.net"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "
DEPEND="=x11-libs/gtk+-1.2*
		dev-perl/gtk-perl
		net-misc/esms"
SLOT="0"
src_unpack() {
	unpack gtkesms-0.0.4.tar.gz
	cd ${WORKDIR}/gtkesms-0.0.4
	patch configure < ${FILESDIR}/gtkesms.patch || die "gtk patch failed"
}

src_compile() {
	econf || die "econf failed"
	make || die "make failed"
}

src_install () {
	make DESTDIR=${D} install || die "install failed"
}
