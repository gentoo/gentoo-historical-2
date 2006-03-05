# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ipmitool/ipmitool-1.8.6.ebuild,v 1.1 2006/03/05 18:18:06 hansmi Exp $

DESCRIPTION="Utility for controlling IPMI enabled devices."
HOMEPAGE="http://ipmitool.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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
	rm ${D}/usr/share/${PN}/bmclanconf
	mv ${D}/usr/share/${PN}/ipmi.init* ${D}/usr/share/doc/${PF}/
	mv ${D}/usr/share/${PN} ${D}/usr/share/doc/${PF}/web
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
