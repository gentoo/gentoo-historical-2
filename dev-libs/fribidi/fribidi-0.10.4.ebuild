# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/fribidi/fribidi-0.10.4.ebuild,v 1.5 2003/08/30 12:45:00 weeve Exp $

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"

HOMEPAGE="http://fribidi.sourceforge.net/"
SRC_URI="mirror://sourceforge/fribidi/${P}.tar.bz2"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE=""

DEPEND="virtual/glibc"

S="${WORKDIR}/${P}"

src_compile() {
	econf || die
	emake || die
	make test || die
}

src_install() {
	einstall || die

	dodoc COPYRIGHT AUTHORS NEWS README ChangeLog \
		INSTALL THANKS TODO ANNOUNCE COPYING
}

