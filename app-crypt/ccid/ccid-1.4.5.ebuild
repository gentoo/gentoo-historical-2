# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ccid/ccid-1.4.5.ebuild,v 1.6 2012/08/22 12:03:09 xmw Exp $

EAPI="4"

STUPID_NUM="3672"

inherit eutils

DESCRIPTION="CCID free software driver"
HOMEPAGE="http://pcsclite.alioth.debian.org/ccid.html"
SRC_URI="http://alioth.debian.org/download.php/${STUPID_NUM}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ~ppc64 x86"
IUSE="twinserial +usb"

DEPEND=">=sys-apps/pcsc-lite-1.6.5
	usb? ( virtual/libusb:1 )"
RDEPEND="${DEPEND}"

DOCS=( README AUTHORS )

src_prepare() {
	sed -i -e 's:GROUP="pcscd":ENV{PCSCD}="1":' \
		src/92_pcscd_ccid.rules || die
}

src_configure() {
	econf \
		LEX=: \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable twinserial) \
		$(use_enable usb libusb)
}

src_install() {
	default

	insinto /lib/udev/rules.d
	doins src/92_pcscd_ccid.rules
}
