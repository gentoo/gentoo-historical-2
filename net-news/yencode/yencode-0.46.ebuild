# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/yencode/yencode-0.46.ebuild,v 1.13 2004/05/28 17:31:21 vapier Exp $

DESCRIPTION="yEnc encoder/decoder package"
HOMEPAGE="http://www.yencode.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc arm"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} || die "./configure failed"

	emake || die
}

src_install () {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	dodoc AUTHORS NEWS README ChangeLog
	doman doc/ydecode.1 doc/yencode.1 doc/ypost.1 doc/ypostrc.5
}
