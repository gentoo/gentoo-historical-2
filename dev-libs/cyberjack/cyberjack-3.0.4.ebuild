# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyberjack/cyberjack-3.0.4.ebuild,v 1.3 2009/05/16 09:22:27 robbat2 Exp $

inherit eutils flag-o-matic autotools

MY_P="ctapi-${P/_/}"

DESCRIPTION="REINER SCT cyberJack pinpad/e-com USB user space driver library"
HOMEPAGE="http://www.reiner-sct.de/ http://sourceforge.net/projects/libchipcard/"
SRC_URI="mirror://sourceforge/libchipcard/${MY_P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="noudev pcsc-lite"

RDEPEND="=virtual/libusb-0*
	pcsc-lite? ( sys-apps/pcsc-lite	)"
DEPEND="${RDEPEND}
	pcsc-lite? ( dev-util/pkgconfig )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	useq noudev || enewgroup "${PN}"
}

src_unpack() {
	unpack ${A} || die "Unpacking failed."
	cd "${S}" || die "Failed to change to source directory."
	useq noudev || {
		epatch "${FILESDIR}/${P}-udev.patch" || die "Applying udev patch failed."
		cp ${FILESDIR}/cyberjack.sh etc/udev/ || die "Copying udev script failed."
		cp ${FILESDIR}/cyberjack.rules etc/udev/rules.new || die "Copying udev rules failed."
	}
	AT_M4DIR="m4" eautoreconf || die "Adopting configurations failed."
}

src_compile() {
	append-flags -fno-strict-aliasing
	local with_usbdropdir=''
	useq pcsc-lite && with_usbdropdir="--with-usbdropdir=$(pkg-config libpcsclite --variable=usbdropdir)"
	./configure \
		--prefix=/usr \
		--docdir=/usr/share/doc/"${P}" \
		--sysconfdir=/etc/"${PN}" \
		$(use_enable pcsc-lite pcsc) \
		${with_usbdropdir} \
		$(use_enable !noudev udev) \
		|| die "Configuration of package failed."
	emake || die "Compilation of package failed."
}

src_install() {
	emake install DESTDIR="${D}" || die "Installation of package failed."
	dodoc ChangeLog NEWS doc/README.txt
}

pkg_postinst() {
	local conf="/etc/${PN}/${PN}.conf"
	elog
	elog "To configure logging, key beep behaviour etc. you need to"
	elog "copy ${conf}.default"
	elog "to ${conf}"
	elog "and modify the latter as needed."
	elog
	useq noudev || {
		elog "Please run the following command as root to"
		elog "make udevd read the cyberJack rules that were"
		elog "just installed onto your system:"
		elog
		elog "  udevcontrol reload_rules"
		elog
		elog "To be able to use the cyberJack device, you need to"
		elog "be a member of the group 'cyberjack' which has just"
		elog "been added to your system. You can add your user to"
		elog "the group by running the following command as root:"
		elog
		elog "  gpasswd -a youruser cyberjack"
		elog
		elog "Please be aware that you need to re-login to your"
		elog "system for the group membership to take effect."
		elog
	}
}
