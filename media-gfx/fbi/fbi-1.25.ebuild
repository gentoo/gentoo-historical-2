# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fbi/fbi-1.25.ebuild,v 1.4 2003/07/12 16:44:48 aliz Exp $

IUSE=""

S="${WORKDIR}/${P}"
DESCRIPTION="fbi a framebuffer image viewer"
SRC_URI="http://bytesex.org/misc/${P/-/_}.tar.gz"
HOMEPAGE="http://bytesex.org/fbi.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~hppa"

DEPEND=">=media-libs/jpeg-6b"

src_compile() {
	export CFLAGS="${CFLAGS}"
	make CC=gcc || die
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		install || die
	
	dodoc COPYING README
}
