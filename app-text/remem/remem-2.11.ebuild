# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/remem/remem-2.11.ebuild,v 1.13 2005/01/01 16:33:30 eradicator Exp $

DESCRIPTION="Remembrance Agent plugin for Emacs"
HOMEPAGE="http://www.remem.org/index.html"
SRC_URI="http://www.remem.org/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND=""

src_compile() {
	lispdir=/usr/share/emacs/site-lisp \
		./configure --host=${CHOST} --prefix=/usr || die "./configure failed"
	make || die "make failed" # emake caused weirdness
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}
