# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gtkhx/gtkhx-0.9.3.ebuild,v 1.9 2004/05/04 05:06:50 eradicator Exp $

IUSE=""

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="a GTK+ Hotline Client based off of Hx"
SRC_URI="http://gtkhx.sourceforge.net/files/${P}.tar.gz"
HOMEPAGE="http://gtkhx.sourceforge.net/index.html"

DEPEND="=x11-libs/gtk+-1.2*"
RDEPEND="$DEPEND"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_compile() {
	econf || die

	emake || die
}

src_install () {

	einstall || die
	dohtml -r doc
	dodoc doc/AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
