# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-www/wsmake/wsmake-0.6.4.ebuild,v 1.3 2003/09/06 01:54:09 msterret Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Website Pre-processor"
HOMEPAGE="http://www.wsmake.org/"
SRC_URI="http://ftp.wsmake.org/pub/wsmake6/stable/wsmake-0.6.4.tar.bz2
http://ftp.wsmake.org/pub/wsmake6/docs/user-manual.pdf
http://ftp.wsmake.org/pub/wsmake6/docs/user-manual.ps
http://ftp.wsmake.org/pub/wsmake6/docs/user-manual-html.tar.gz"

KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

src_unpack () {
	unpack ${P}.tar.bz2
	cd ${S}
	#Apply patch to allow compiling
	patch -p0 < ${FILESDIR}/${P}-bv.diff || die
	unpack user-manual-html.tar.gz
}

src_compile () {
	./configure --prefix=/usr  || die
	emake || die
	cd doc
	tar -cf examples.tar examples || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS Artistic COPYING ChangeLog* DEVELOPERS LICENSE NEWS README TODO
	cd user-manual
	dohtml * stylesheet-images/*
	cd ../doc
	dodoc manual.txt examples.tar
}

