# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hotplug/hotplug-20040401.ebuild,v 1.12 2007/04/28 16:27:15 swegener Exp $

inherit eutils

# source maintainers named it hotplug-YYYY_MM_DD instead of hotplug-YYYYMMDD
MY_P=${PN}-${PV:0:4}_${PV:4:2}_${PV:6:2}
S=${WORKDIR}/${MY_P}
DESCRIPTION="USB and PCI hotplug scripts"
HOMEPAGE="http://linux-hotplug.sourceforge.net"
SRC_URI="mirror://kernel/linux/utils/kernel/hotplug/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ~ia64 ~mips"
IUSE=""

# hotplug needs pcimodules utility provided by pcitutils-2.1.9-r1
DEPEND=">=sys-apps/pciutils-2.1.9
	>=sys-apps/usbutils-0.9
	sys-apps/hotplug-base"

src_unpack() {
	unpack ${A}
	cd ${S}

	# patches go here if needed...
}

src_install() {
	into /
	doman *.8
	dodoc README ChangeLog

	cd ${S}/etc/hotplug
	insinto /etc/hotplug
	doins blacklist hotplug.functions usb.distmap usb.handmap usb.usermap
	exeinto /etc/hotplug
	doexe *.agent *.rc *.permissions
	dodir /usr/lib/hotplug/firmware
	dodir /etc/hotplug/usb
	dodir /etc/hotplug/pci
	cd ${S}/etc/hotplug.d/default
	exeinto /etc/hotplug.d/default
	doexe default.hotplug

	newinitd ${FILESDIR}/hotplug.rc hotplug

	newconfd ${FILESDIR}/usb.confd usb
	dodir /var/run/usb
}

pkg_postinst() {
	ewarn "WARNING: The fxload program was spliced off this package"
	ewarn "WARNING: emerge fxload if you need it"
}
