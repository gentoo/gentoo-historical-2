# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcoincoin/wmcoincoin-2.4.5b.ebuild,v 1.3 2004/04/30 22:29:05 pvdabeel Exp $

IUSE=""

DESCRIPTION="Dockapp for browsing Dacode sites news and board"
HOMEPAGE="http://hules.free.fr/wmcoincoin"
SRC_URI="mirror://sourceforge/dacode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64 ppc"

DEPEND="virtual/glibc
	virtual/x11"

src_compile() {
	econf || die "configure failed"

	emake || die "parallel make failed"
}

src_install () {
	einstall || die "make install failed"

	dobin wmcoincoin wmpanpan

	dodoc README AUTHORS Changelog
	docinto examples

	insinto /usr/share/wmcoincoin
	doins options useragents
}
