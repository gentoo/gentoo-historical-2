# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/hotkeys/hotkeys-0.5.4.ebuild,v 1.8 2002/12/09 04:41:52 manson Exp $

NAME="hotkeys"
S=${WORKDIR}/${P}
DESCRIPTION="Make use of extra buttons on newer keyboards."
SRC_URI="http://ypwong.org/hotkeys/hotkeys_0.5.4.tar.gz"
HOMEPAGE="http://ypwong.org/hotkeys/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc "

DEPEND="virtual/x11
	virtual/glibc
	dev-libs/libxml2
	>=sys-libs/db-3.2.3
	=x11-libs/xosd-0.7.0"


src_unpack() {
	unpack ${A}
	cd ${S}
	zcat ${FILESDIR}/${P}-gentoo.diff.gz | patch -p0
}

src_compile() {
	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--libdir=/usr/lib/xosd-0.7.0 \
		--includedir=/usr/include/xosd-0.7.0 \
		--sysconfdir=/etc || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS ChangeLog COPYING README TODO
}

