# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxml/libxml-1.8.16.ebuild,v 1.1 2001/10/08 08:26:38 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="libxml"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND=">=sys-libs/ncurses-5.2"

DEPEND="${RDEPEND}
        >=sys-libs/readline-4.1"


src_compile() {
	LDFLAGS="-lncurses" ./configure --host=${CHOST} 		\
	                                --prefix=/usr	 		\
				        --sysconfdir=/etc		\
					--localstatedir=/var/lib
	assert

	make || die # Doesn't work with -j 4 (hallski)
}

src_install() {
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die

	dodoc AUTHORS COPYING* ChangeLog NEWS README
}







