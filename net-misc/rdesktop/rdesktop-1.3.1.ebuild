# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rdesktop/rdesktop-1.3.1.ebuild,v 1.3 2004/02/16 00:25:07 pylon Exp $

DESCRIPTION="A Remote Desktop Protocol Client"
HOMEPAGE="http://rdesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="ssl debug"

DEPEND="x11-base/xfree
	ssl? ( >=dev-libs/openssl-0.9.6b )"

src_unpack() {
	unpack ${A}
}

src_compile() {
	local myconf
	use ssl \
		&& myconf="--with-openssl=/usr/include/openssl" \
		|| myconf="--without-openssl"

	sed -e "s:-O2:${CFLAGS}:g" Makefile > Makefile.tmp
	mv Makefile.tmp Makefile
	echo "CFLAGS += ${CXXFLAGS}" >> Makeconf

	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--sharedir=/usr/share/${PN} \
		`use_with debug` \
		${myconf} || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install
	dodoc COPYING doc/HACKING doc/TODO doc/keymapping.txt
}
