# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/apotheke/apotheke-0.1.ebuild,v 1.4 2002/10/04 05:36:09 vapier Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="A seperate Nautilus view, which gives you detailed information about CVS managed directories."
SRC_URI="ftp://ftp.berlios.de/pub/apotheke/${P}.tar.gz"
HOMEPAGE="http://apotheke.berlios.de/"
LICENSE="GPL-2"
DEPEND=">=nautilus-2.0.0"
RDEPEND="${DEPEND}"
SLOT="0"
KEYWORDS="x86 sparc sparc64"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}
