# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkeycaps/xkeycaps-2.46.ebuild,v 1.11 2003/10/19 06:01:46 mr_bones_ Exp $

DESCRIPTION="GUI frontend to xmodmap"
SRC_URI="http://www.jwz.org/${PN}/${P}.tar.Z"
HOMEPAGE="http://www.jwz.org/xkeycaps/"

LICENSE="as-is"
KEYWORDS="x86 sparc ppc"
SLOT="0"
IUSE=""

RDEPEND="virtual/x11"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_compile() {
	xmkmf || die
	sed -i \
		-e "s,all:: xkeycaps.\$(MANSUFFIX).html,all:: ,g" \
		Makefile || \
			die "sed Makefile failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README *.txt        || die "dodoc failed"
}
