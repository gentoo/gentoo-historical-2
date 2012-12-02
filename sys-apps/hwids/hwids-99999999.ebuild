# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwids/hwids-99999999.ebuild,v 1.6 2012/12/02 08:13:23 ssuominen Exp $

EAPI=5
inherit udev

DESCRIPTION="Hardware (PCI, USB) IDs databases"
HOMEPAGE="https://github.com/gentoo/hwids"

# freedist is for oui.txt, and it's mostly wishful thinking
LICENSE="|| ( GPL-2 BSD ) freedist"
SLOT="0"
KEYWORDS=""
IUSE="+udev"

S=${WORKDIR}

DEPEND="net-misc/wget
	udev? ( dev-lang/perl !=sys-fs/udev-196 )"
RDEPEND="!<sys-apps/pciutils-3.1.9-r2
	!<sys-apps/usbutils-005-r1"

src_compile() {
	wget http://pci-ids.ucw.cz/v2.2/pci.ids.gz http://www.linux-usb.org/usb.ids.gz http://standards.ieee.org/develop/regauth/oui/oui.txt || die

	for file in {usb,pci}.ids; do
		zcat ${file}.gz > ${file} || die
	done

	if use udev; then
		wget http://cgit.freedesktop.org/systemd/systemd/plain/hwdb/ids-update.pl -O ids-update-${PV}.pl || die
		perl ids-update-${PV}.pl &>/dev/null || die
	fi
}

src_install() {
	insinto /usr/share/misc
	doins {usb,pci}.ids{,.gz} oui.txt

	if use udev; then
		insinto "$(udev_get_udevdir)"/hwdb.d
		doins *.hwdb
	fi
}

pkg_postinst() {
	if use udev && has_version '>=virtual/udev-180'; then
		udevadm hwdb --update
	fi
}
