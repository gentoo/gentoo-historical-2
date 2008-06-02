# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cisco-vpnclient-3des/cisco-vpnclient-3des-4.8.01.0640.ebuild,v 1.4 2008/06/02 22:22:04 wolf31o2 Exp $

inherit eutils linux-mod

MY_PV=${PV}-k9

DESCRIPTION="Cisco VPN Client (3DES)"
HOMEPAGE="http://cco.cisco.com/en/US/products/sw/secursw/ps2308/index.html"
SRC_URI="vpnclient-linux-x86_64-${MY_PV}.tar.gz"

LICENSE="cisco-vpn-client"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch mirror strip"

S=${WORKDIR}/vpnclient

VPNDIR="/opt/cisco-vpnclient"
CFGDIR="/etc/${VPNDIR}"
OLDCFG="/etc/CiscoSystemsVPNClient"

QA_TEXTRELS="${VPNDIR:1}/lib/libvpnapi.so"
QA_EXECSTACK="${VPNDIR:1}/lib/libvpnapi.so
	${VPNDIR:1}/bin/vpnclient
	${VPNDIR:1}/bin/cvpnd
	${VPNDIR:1}/bin/cisco_cert_mgr
	${VPNDIR:1}/bin/ipseclog"

MODULE_NAMES="cisco_ipsec(CiscoVPN)"
BUILD_TARGETS="clean default"

pkg_nofetch() {
	einfo "Please visit:"
	einfo " ${HOMEPAGE}"
	einfo "and download ${A} to ${DISTDIR}"
}

src_unpack () {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-amd64.patch
	epatch "${FILESDIR}"/${PV}-2.6.24.patch
}

src_install() {
	local binaries="vpnclient ipseclog cisco_cert_mgr"
	linux-mod_src_install

	# Binaries
	exeinto /opt/cisco-vpnclient/bin
	exeopts -m0111
	doexe ${binaries}
	exeopts -m4111
	doexe cvpnd
	# Libraries
	insinto /opt/cisco-vpnclient/lib
	doins libvpnapi.so
	# Includes
	insinto /opt/cisco-vpnclient/include
	doins vpnapi.h

	# Configuration files/profiles/etc
	insinto ${CFGDIR}
	doins vpnclient.ini
	insinto ${CFGDIR}/Profiles
	doins *.pcf
	dodir ${CFGDIR}/Certificates

	# Create some symlinks
	dodir /usr/bin
	for filename in ${binaries}
	do
		dosym ${VPNDIR}/bin/${filename} /usr/bin/${filename}
	done

	# Make sure we keep these, even if they're empty.
	keepdir ${CFGDIR}/Certificates
	keepdir ${CFGDIR}/Profiles
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if [ -e "${OLDCFG}" ]
	then
		elog "Found an old ${OLDCFG} configuration directory."
		elog "Moving ${OLDCFG} files to ${CFGDIR}."
		cp -pPR ${OLDCFG}/* ${CFGDIR} && rm -rf ${OLDCFG}
	fi
	if [ -e "/etc/init.d/vpnclient" ]
	then
		elog "Removing /etc/init.d/vpnclient, which is no longer needed."
		rm -f /etc/init.d/vpnclient
	fi
	runlevels=`rc-update show | grep vpnclient | cut -d\| -f2`
	if [ -n "$runlevels" ]
	then
		elog "Removing 'vpnclient' from all runlevels."
		rc-update del vpnclient
	fi
	elog "You will need to load the cisco_ipsec module before using the Cisco"
	elog "VPN Client (vpnclient) application."
}
