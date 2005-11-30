# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ipmitool/ipmitool-1.6.0.ebuild,v 1.1 2005/03/01 08:15:19 robbat2 Exp $

DESCRIPTION="Utility for controlling IPMI enabled devices."
HOMEPAGE="http://${PN}.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
IUSE=""
SLOT="0"
KEYWORDS="~x86"
LICENSE="BSD"

RDEPEND="virtual/libc
		dev-libs/openssl"
DEPEND="${RDEPEND}
		virtual/os-headers"
		
src_compile() {
	econf \
		--enable-ipmievd --enable-ipmishell \
		--enable-intf-lan --enable-intf-lanplus \
		--enable-intf-open --enable-intf-imb \
		--with-kerneldir=yes --bindir=/usr/sbin \
		|| die "econf failed"
	# Fix linux/ipmi.h to compile properly. This is a hack since it doesn't
	# include the below file to define some things.
	echo "#include <asm/byteorder.h>" >>config.h
	emake || die "emake failed"

}

src_install() {
	emake DESTDIR="${D}" PACKAGE="${PF}" install || die "emake install failed"
	rm ${D}/usr/share/${PN}/{bmclanconf,ipmi.init}
	into /usr
	dosbin contrib/bmclanconf
}

requestinitd() {
	einfo "Could somebody please write an init.d script for ipmievd, and submit it?"
}

pkg_preinst() {
	requestinitd
}

pkg_postinst() {
	requestinitd
}
