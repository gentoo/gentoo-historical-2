# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/trafshow/trafshow-3.1-r1.ebuild,v 1.2 2002/07/11 06:30:45 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Full screen visualization of the network traffic"
SRC_URI="ftp://ftp.nsk.su/pub/RinetSoftware/${P}.tgz"
HOMEPAGE="http://soft.risp.ru/trafshow/index_en.shtml"
LICENSE="Freeware"
SLOT="3"

DEPEND="net-libs/libpcap
	sys-libs/ncurses
	slang? ( >=sys-libs/slang-1.4.2 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	if use slang; then
		: slang is the default
	else
		# No command-line option so pre-cache instead
		export ac_cv_have_curses=ncurses
		export LIBS=-lncurses
	fi
	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=\${prefix}/share/man \
		--enable-ipv6 || die "./configure failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
}
