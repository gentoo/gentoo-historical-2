# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cisco-vpnclient-3des/cisco-vpnclient-3des-4.0.3b-r4.ebuild,v 1.4 2004/07/01 20:54:27 squinky86 Exp $

inherit eutils

MY_PV=${PV/b/.B-k9}
DESCRIPTION="Cisco VPN Client (3DES)"
HOMEPAGE="http://cco.cisco.com/en/US/products/sw/secursw/ps2308/index.html"
SRC_URI="vpnclient-linux-${MY_PV}.tar.gz"

LICENSE="cisco-vpn-client"
SLOT="${KV}"
KEYWORDS="-* x86"
RESTRICT="fetch"
IUSE=""

DEPEND="virtual/libc
	virtual/linux-sources
	>=sys-apps/sed-4"

S=${WORKDIR}/vpnclient

VPNDIR="/etc/CiscoSystemsVPNClient"

pkg_nofetch() {
	eerror "Please goto:"
	eerror " ${HOMEPAGE}"
	eerror "and download"
	eerror " ${A}"
	eerror "to ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Patch to allow use of alternate CC.  Patch submitted to bug #33488 by
	# Jesse Becker <jbecker@speakeasy.net>
	epatch ${FILESDIR}/driver_build_CC.patch
	# Patch to allow module to work with kernel 2.6.x.  Patch submitted to bug
	# #40730 by Kent Skaar <skaar@aol.net>.  Patch originally submitted to LMKL
	# by Gertjan van Wingerde <gwingerde@home.nl>.
	epatch ${FILESDIR}/register_netdevice.patch
	# Patch to allow module to work with Atheros chipsets.  Patch submitted to
	# bug #48680 by Dominic Battre <dominic.battre@gmx.de>
	epatch ${FILESDIR}/atheros.patch
}

src_compile () {
	check_KV
	sh ./driver_build.sh /lib/modules/${KV}/build
	[ ! -f ./cisco_ipsec ] && die "Failed to make module 'cisco_ipsec'"
	sed -i "s#@VPNBINDIR@#/usr/bin#" vpnclient_init
	sed -i "s#@VPNBINDIR@#/usr/bin#" vpnclient.ini.in
}

src_install() {
	exeinto /etc/init.d
	#newexe vpnclient_init vpnclient
	newexe ${FILESDIR}/vpnclient.rc vpnclient

	exeinto /usr/bin
	exeopts -m0711
	doexe vpnclient
	exeopts -m4711
	doexe cvpnd
	dobin ipseclog cisco_cert_mgr

	insinto /lib/modules/${KV}/CiscoVPN
	doins cisco_ipsec

	insinto ${VPNDIR}
	newins vpnclient.ini.in vpnclient.ini
	insinto ${VPNDIR}/Profiles
	doins *.pcf
	dodir ${VPNDIR}/Certificates
}

pkg_postinst() {
	einfo  "You must run \`/etc/init.d/vpnclient start\` before using the client."
}
