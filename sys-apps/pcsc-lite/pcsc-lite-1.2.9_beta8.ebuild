# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcsc-lite/pcsc-lite-1.2.9_beta8.ebuild,v 1.1 2005/10/04 23:55:50 vapier Exp $

STUPID_NUM=1133
MY_P="${PN}-${PV/_/-}"
DESCRIPTION="PC/SC Architecture smartcard middleware library"
HOMEPAGE="http://www.linuxnet.com/middle.html"
SRC_URI="https://alioth.debian.org/download.php/${STUPID_NUM}/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="static debug"

RDEPEND="!static? ( dev-libs/libusb )"
DEPEND="dev-libs/libusb
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--enable-extendedapdu \
		--enable-usbdropdir=/usr/lib/readers/usb \
		--enable-muscledropdir=/usr/share/pcsc/services \
		$(use_enable debug) \
		$(use_enable static) \
		|| die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog DRIVERS HELP INSTALL NEWS README SECURITY
	dodoc doc/*.pdf doc/README.DAEMON
	docinto sample
	dodoc src/utils/README src/utils/sample.*
	rm -r "${D}"/usr/doc

	newinitd "${FILESDIR}"/pcscd-init pcscd
	newconfd "${FILESDIR}"/pcscd-confd pcscd
}

pkg_postinst() {
	ewarn "You should run 'revdep-rebuild --soname libpcsclite.so.0'"
}
