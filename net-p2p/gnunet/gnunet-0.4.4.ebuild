# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet/gnunet-0.4.4.ebuild,v 1.4 2003/02/13 15:19:25 vapier Exp $

S=${WORKDIR}/GNUnet-${PV}
DESCRIPTION="GNUnet is an anonymous, distributed, reputation based network."
HOMEPAGE="http://www.ovmj.org/GNUnet/index.php3"
SRC_URI="http://www.ovmj.org/GNUnet/download/GNUnet-${PV}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-libs/openssl-0.9.6d
	>=sys-libs/gdbm-1.8.0
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=dev-libs/libextractor-0.1.0"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING INSTALL NEWS README
	dodir /usr/share/gnunet
	cp ${S}/contrib/gnunet.conf* ${D}/usr/share/gnunet
	cp ${FILESDIR}/gnunet ${D}/usr/share/gnunet
	
}

pkg_postinst() {
	einfo "Default configuration files are provided in /usr/share/gnunet"
	einfo "An example rc script for gentoo is also available and "
	einfo "should be run by permanent nodes."
	einfo "Read the docs for more details"
}
