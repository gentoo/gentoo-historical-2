# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glimpse/glimpse-4.15.ebuild,v 1.5 2002/10/17 00:14:17 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A index/query system to search a large set of files quickly"
SRC_URI="http://webglimpse.net/trial/${P}.tar.gz"
HOMEPAGE="http://webglimpse.net"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"

src_compile() {
	make clean
	econf || die "./configure failed"
	make || die
}

src_install() {
	einstall || die
	doman *.1 	
}
