# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/poslib/poslib-1.0.4.ebuild,v 1.5 2004/12/14 09:32:26 matsuu Exp $

DESCRIPTION="A library for creating C++ programs using the Domain Name System"
HOMEPAGE="http://www.posadis.org/projects/poslib.php"
SRC_URI="mirror://sourceforge/posadis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE="ipv6"

DEPEND="virtual/libc"

src_compile() {
	econf \
		--with-cxxflags="${CXXFLAGS} -funsigned-char" \
		`use_enable ipv6` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
