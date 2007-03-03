# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openct/openct-0.6.9.ebuild,v 1.9 2007/03/03 23:10:40 genone Exp $

inherit eutils multilib

DESCRIPTION="library for accessing smart card terminals"
HOMEPAGE="http://www.opensc-project.org/openct/"
SRC_URI="http://www.opensc-project.org/files/openct/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ia64 m68k ~mips ~ppc ppc64 s390 sh sparc x86"
IUSE="usb"

RDEPEND="usb? (	>=dev-libs/libusb-0.1.7
	|| ( >=sys-fs/udev-096 >=sys-apps/hotplug-20040923 ) )"

pkg_setup() {
	enewgroup openct
}

src_compile() {
	econf --localstatedir=/var || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	if use usb ; then
		insinto /etc/hotplug/usb
		doins etc/openct.usermap || die
		exeinto /etc/hotplug/usb
		newexe etc/openct_usb openct || die
	fi

	sed -i 's|RUN+="/lib/udev/|RUN+="/etc/udev/scripts/|' etc/openct.udev
	insinto /etc/udev/rules.d/
	newins etc/openct.udev 70-openct.rules || die
	exeinto /etc/udev/scripts/
	newexe etc/openct_pcmcia openct_pcmcia || die
	newexe etc/openct_serial openct_serial || die
	newexe etc/openct_usb openct_usb || die

	insinto /etc
	doins etc/openct.conf || die

	newinitd "${FILESDIR}"/openct.rc openct

	diropts -m0750 -gopenct
	keepdir /var/run/openct

	dodoc NEWS TODO doc/README
}

pkg_preinst() {
	if [[ -e ${ROOT}/usr/$(get_libdir)/libopenct.so.0 ]] ; then
		cp "${ROOT}"/usr/$(get_libdir)/libopenct.so.0 "${IMAGE}"/usr/lib/
	fi
}

pkg_postinst() {
	elog "You need to edit /etc/openct.conf to enable serial readers."
	elog
	elog "To use hotplugging (USB readers) your kernel has to be compiled"
	elog "with CONFIG_HOTPLUG enabled."
	elog
	elog "You should add \"openct\" to your default runlevel. To do so"
	elog "type \"rc-update add openct default\"."
	elog
	elog "You need to be a member of the (newly created) group openct to"
	elog "access smart card readers connected to this system. Set users'"
	elog "groups with usermod -G.  root always has access."
	if [[ -e ${ROOT}/usr/$(get_libdir)/libopenct.so.0 ]] ; then
		echo
		ewarn "Please run: revdep-rebuild --library libopenct.so.0"
		echo
	fi
}
