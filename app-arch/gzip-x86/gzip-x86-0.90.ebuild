# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/gzip-x86/gzip-x86-0.90.ebuild,v 1.3 2004/06/06 14:35:35 dragonheart Exp $


MY_P=${PN/-/_}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="gzip_x86 is an optimized gzip for x86 arch.  5-45% speed increase is offered during decompression"
HOMEPAGE="ftp://spruce.he.net/pub/jreiser"
SRC_URI="ftp://spruce.he.net/pub/jreiser/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="-* x86 amd64"

DEPEND="virtual/glibc"

PROVIDE="virtual/gzip"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
