# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gtkhx/gtkhx-0.9.3.ebuild,v 1.3 2002/07/11 06:30:49 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a GTK+ Hotline Client based off of Hx"
SRC_URI="http://gtkhx.sourceforge.net/files/${P}.tar.gz"
HOMEPAGE="http://gtkhx.sourceforge.net/index.html"
SLOT="0"

DEPEND="virtual/glibc
         =x11-libs/gtk+-1.2*"

RDEPEND="$DEPEND"

src_compile() {
	econf || die

	emake || die
}

src_install () {

	einstall || die
		dohtml doc/*.html
		dodoc   doc/AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
