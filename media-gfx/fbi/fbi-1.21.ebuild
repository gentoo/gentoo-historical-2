# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fbi/fbi-1.21.ebuild,v 1.9 2003/09/06 23:56:38 msterret Exp $

S=${WORKDIR}/${P}
DESCRIPTION="fbi a framebuffer image viewer"
SRC_URI="http://www.strusel007.de/linux/misc/${P/-/_}.tar.gz"
HOMEPAGE="http://www.strusel007.de/linux/fbi.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 alpha"

DEPEND=">=media-libs/jpeg-6b"

src_compile() {
	export CFLAGS="${CFLAGS}"
	make CC=gcc || die
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
		install || die

	dodoc COPYING README
}
