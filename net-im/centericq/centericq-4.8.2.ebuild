# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/centericq/centericq-4.8.2.ebuild,v 1.1 2002/08/19 16:07:20 rphillips Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A ncurses ICQ/Yahoo!/MSN Client"
SRC_URI="http://konst.org.ua/download/${P}.tar.gz"
HOMEPAGE="http://konst.org.ua/eng/software/centericq/info.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2
	=dev-libs/libsigc++-1.0*"

RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}

	cd ${S}

	use nls && patch -l -p0 <${FILESDIR}/${P}.patch
}

src_compile() {
	local myopts=""

	use nls || myopts="--disable-nls"
	
	./configure --prefix=/usr \
		--host=${CHOST} \
		--with-included-gettext \
		${myopts} || die "Configure failed"
	
	emake || die "Compilation failed"
}

src_install () {
	make DESTDIR=${D} install || die "Installation failed"

	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING FAQ README THANKS TODO
}
