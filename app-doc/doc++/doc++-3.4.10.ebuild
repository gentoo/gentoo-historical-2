# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/doc++/doc++-3.4.10.ebuild,v 1.4 2004/05/31 18:31:34 vapier Exp $

DESCRIPTION="Documentation system for C, C++, IDL and Java"
HOMEPAGE="http://docpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/docpp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	./configure -prefix /usr || die
	make all || die
}

src_install() {
	einstall || die
	dodoc CREDITS INSTALL NEWS PLATFORMS REPORTING-BUGS
}
