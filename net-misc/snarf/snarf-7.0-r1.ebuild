# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/snarf/snarf-7.0-r1.ebuild,v 1.11 2002/12/09 04:33:19 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A full featured small web-spider"
SRC_URI="http://www.xach.com/snarf/${P}.tar.gz"
HOMEPAGE="http://www.xach.com/snarf/"
KEYWORDS="x86 ppc sparc "
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {													 
	econf || die
	make || die
}

src_install() {															 
	into /usr
	dobin snarf
	doman snarf.1
	dodoc COPYING ChangeLog README TODO
}
