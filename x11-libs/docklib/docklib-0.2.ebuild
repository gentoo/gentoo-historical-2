# Copyright (c) Vitaly Kushneriuk
# Distributed under the terms of the GNU General Public License, v2.
# Maintainer: Vitaly Kushneriuk<vitaly@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-libs/docklib/docklib-0.2.ebuild,v 1.2 2002/07/09 10:53:20 aliz Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Library for Window Maker dock applications."
SRC_URI="http://linuxberg.surfnet.nl/files/x11/dev/docklib-0.2.tar.gz"
HOMEPAGE="http://www.windowmaker.org"
DEPEND="x11-base/xfree"
#RDEPEND=""
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

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
	#make \
	#	prefix=${D}/usr \
	#	mandir=${D}/usr/share/man \
	#	infodir=${D}/usr/share/info \
	#	install || die
}
