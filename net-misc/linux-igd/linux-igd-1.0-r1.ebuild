# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/linux-igd/linux-igd-1.0-r1.ebuild,v 1.1 2007/02/25 12:57:46 gurligebis Exp $

DESCRIPTION="Deamon that emulates Microsoft's Internet Connection Sharing (ICS)
		for UPnP-aware clients"
HOMEPAGE="http://linux-igd.sourceforge.net"
SRC_URI="mirror://sourceforge/linux-igd/linuxigd-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-misc/libupnp-1.4.1"
RDEPEND="net-firewall/iptables"
S=${WORKDIR}/linuxigd-${PV}

src_compile() {
	sed -i -e "s|/etc/linuxigd|${D}/etc/linuxigd|" \
			-e "s|/usr/bin|${D}/usr/bin|" Makefile
	sed -i -e "s|/etc/upnpd.conf|/etc/linuxigd/upnpd.conf|" globals.h

	emake || die "compile failed"
}

src_install() {
	dobin upnpd
	insinto /etc/linuxigd
	doins etc/dummy.xml
	doins etc/gateconnSCPD.xml
	doins etc/gatedesc.xml
	doins etc/gateicfgSCPD.xml
	doins etc/ligd.gif
	doins etc/upnpd.conf

	newinitd ${FILESDIR}/upnpd.initd-${PVR} upnpd
	newconfd ${FILESDIR}/upnpd.confd-${PVR} upnpd

	dodoc CHANGES INSTALL LICENSE
}

pkg_postinst() {
	einfo "Make sure your firewall allows routing of packages"
	einfo "to 239.0.0.0/255.0.0.0 correctly."
}
