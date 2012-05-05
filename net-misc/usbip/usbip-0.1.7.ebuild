# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/usbip/usbip-0.1.7.ebuild,v 1.2 2012/05/05 03:20:43 jdhore Exp $

EAPI="2"

inherit autotools

DESCRIPTION="Userspace utilities for a general USB device sharing system over IP networks"
HOMEPAGE="http://usbip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="sys-fs/sysfsutils
	sys-apps/tcp-wrappers
	dev-libs/glib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/automake-1.9
	sys-devel/libtool"

S="${WORKDIR}/${P}/src"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "Installing userspace tools failed"
	dodoc README || die
}

pkg_postinst() {
	elog "For using USB/IP you need to enable USB_IP_VHCI_HCD in the client"
	elog "machine's kernel config and USB_IP_HOST on the server."
}
