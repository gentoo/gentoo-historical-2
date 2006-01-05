# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hotplug/hotplug-20040923-r1.ebuild,v 1.2 2006/01/05 03:33:31 vapier Exp $

inherit eutils

# source maintainers named it hotplug-YYYY_MM_DD instead of hotplug-YYYYMMDD
MY_P=${PN}-${PV:0:4}_${PV:4:2}_${PV:6:2}
S=${WORKDIR}/${MY_P}
DESCRIPTION="USB and PCI hotplug scripts"
HOMEPAGE="http://linux-hotplug.sourceforge.net"
SRC_URI="mirror://kernel/linux/utils/kernel/hotplug/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""

# hotplug needs pcimodules utility provided by pcitutils-2.1.9-r1
DEPEND=">=sys-apps/pciutils-2.1.9
	>=sys-apps/usbutils-0.9
	sys-apps/hotplug-base"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-ifrename.patch
}

src_install() {
	into /
	doman *.8
	dodoc README README.modules ChangeLog

	cd "${S}"/etc/hotplug
	insinto /etc/hotplug
	doins blacklist hotplug.functions *map || die

	exeinto /etc/hotplug
	doexe *.agent *.rc *.permissions || die
	# stupid isapnp.rc files...
	newexe "${FILESDIR}"/isapnp.rc.empty isapnp.rc

	dodir /usr/lib/hotplug/firmware
	dodir /etc/hotplug/usb
	dodir /etc/hotplug/pci
	cd "${S}"/etc/hotplug.d/default
	exeinto /etc/hotplug.d/default
	doexe default.hotplug || die

	newinitd "${FILESDIR}"/hotplug.rc.empty hotplug
	newconfd "${FILESDIR}"/usb.confd usb
	dodir /var/run/usb
}

pkg_postinst() {
	ewarn "WARNING: The hotplug init script is now gone (dead and burried.)"
	ewarn "WARNING: If you want to load modules for hardware that was already"
	ewarn "WARNING: discovered at boot time, like the old hotplug init script"
	ewarn "WARNING: did, then emerge the coldplug package, and add coldplug to"
	ewarn "WARNING: a runlevel, e.g. # rc-update add coldplug boot"
	echo
	ewarn "WARNING: All firmware loaded by the hotplug scripts needs to be"
	ewarn "WARNING: moved to the /lib/firmware directory, as the scripts now"
	ewarn "WARNING: expect it to be in that location."
	echo
	ewarn "If you still have the file /etc/hotplug/isapnp.rc on your system,"
	ewarn "please delete it by hand, the file /etc/hotplug/pnp.rc superseeds it."
}
