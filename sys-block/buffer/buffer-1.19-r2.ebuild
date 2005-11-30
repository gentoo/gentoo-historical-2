# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/buffer/buffer-1.19-r2.ebuild,v 1.1 2005/03/05 22:30:01 ciaranm Exp $

inherit eutils flag-o-matic gcc

DESCRIPTION="a tapedrive tool for speeding up reading from and writing to tape"
HOMEPAGE="http://www.microwerks.net/~hugo/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-deb-gentoo.patch
	make clean || die "make clean failed"
}

src_compile() {
	append-lfs-flags
	emake CC="$(gcc-getCC)" CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	dobin buffer || die
	dodoc README
	newman buffer.man buffer.1
}
