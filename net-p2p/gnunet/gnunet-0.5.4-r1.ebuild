# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet/gnunet-0.5.4-r1.ebuild,v 1.3 2003/09/07 00:17:35 msterret Exp $

inherit libtool

S="${WORKDIR}/GNUnet-${PV}"
DESCRIPTION="GNUnet is an anonymous, distributed, reputation based network."
HOMEPAGE="http://www.ovmj.org/GNUnet/"
SRC_URI="http://www.ovmj.org/GNUnet/download/GNUnet-${PV}.tar.bz2"

IUSE="ipv6"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-libs/openssl-0.9.6d
	>=sys-libs/gdbm-1.8.0
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=dev-libs/libextractor-0.2.0"


src_compile () {
	elibtoolize
	local myconf
	use ipv6 && myconf="--enable-ipv6" || myconf=" --disable-ipv6"
	econf ${myconf}
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README

	dodir /etc
	cp contrib/gnunet.conf.root ${D}/etc/gnunet.conf
	docinto contrib
	dodoc contrib/*
}

pkg_postinst() {
	use ipv6 && ewarn "ipv6 support is -very- experimental and prone to bug"
    einfo ""
    einfo "now copy an appropriate config file from"
    einfo "/usr/share/doc/${P}/contrib"
    einfo "to ~/.gnunet/gnunet.conf"
    einfo ""
}
