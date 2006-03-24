# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cisco-vpnclient-3des/cisco-vpnclient-3des-4.0.5-r1.ebuild,v 1.1 2006/03/24 15:11:21 wolf31o2 Exp $

inherit eutils linux-info

MY_PV=${PV}.Rel-k9
DESCRIPTION="Cisco VPN Client (3DES)"
HOMEPAGE="http://cco.cisco.com/en/US/products/sw/secursw/ps2308/index.html"
SRC_URI="vpnclient-linux-${MY_PV}.tar.gz"

LICENSE="cisco-vpn-client"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="fetch"

DEPEND="virtual/libc
	virtual/linux-sources
	>=sys-apps/sed-4"

S=${WORKDIR}/vpnclient

VPNDIR="/etc/CiscoSystemsVPNClient"

pkg_nofetch() {
	einfo "Please visit:"
	einfo " ${HOMEPAGE}"
	einfo "and download ${A} to ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Patch to allow use of alternate CC.  Patch submitted to bug #33488 by
	# Jesse Becker <jbecker@speakeasy.net>
	epatch ${FILESDIR}/driver_build_CC.patch
	#Fix problems with the linux >=2.6.14 kernel.
	if kernel_is 2 6 && [ ${KV_PATCH} -ge 14 ]
	then
		epatch ${FILESDIR}/${PV}-2.6.14.patch
	fi
}

src_compile () {
	unset ARCH
	sh ./driver_build.sh /lib/modules/${KV}/build
	[ ! -f ./cisco_ipsec -a ! -f ./cisco_ipsec.ko ] \
		&& die "Failed to make module 'cisco_ipsec'"
	sed -i "s#@VPNBINDIR@#/usr/bin#" vpnclient_init
	sed -i "s#@VPNBINDIR@#/usr/bin#" vpnclient.ini.in
}

src_install() {
	exeinto /etc/init.d
	newexe ${FILESDIR}/vpnclient.rc vpnclient

	exeinto /usr/bin
	exeopts -m0711
	doexe vpnclient
	exeopts -m4711
	doexe cvpnd
	dobin ipseclog cisco_cert_mgr

	insinto /lib/modules/${KV}/CiscoVPN
	if kernel_is 2 6 ; then
		doins cisco_ipsec.ko
	else
		doins cisco_ipsec
	fi

	insinto ${VPNDIR}
	newins vpnclient.ini.in vpnclient.ini
	insinto ${VPNDIR}/Profiles
	doins *.pcf
	dodir ${VPNDIR}/Certificates
}

pkg_postinst() {
	einfo  "You must run \`/etc/init.d/vpnclient start\` before using the client."
}
