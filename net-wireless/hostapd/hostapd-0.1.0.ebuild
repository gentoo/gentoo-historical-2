# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/hostapd/hostapd-0.1.0.ebuild,v 1.2 2003/12/16 19:17:12 wschlich Exp $

inherit eutils

DESCRIPTION="HostAP wireless daemon"
HOMEPAGE="http://hostap.epitest.fi/"
SRC_URI="http://hostap.epitest.fi/releases/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=net-wireless/hostap-driver-0.1.0"
S="${WORKDIR}/${P}"

src_compile() {
	emake CC="${CC}" CFLAGS="${CFLAGS}" || die
}

src_install() {
	diropts -oroot -groot -m0750
	dodir /etc/hostapd
	insopts -oroot -groot -m0640
	insinto /etc/hostapd
	exeopts ""
	exeinto /etc/init.d
	newexe "${FILESDIR}/hostapd.init.d" hostapd
	doins \
		hostapd.conf \
		hostapd.accept \
		hostapd.deny
	dosed 's:\(accept_mac_file=\)/etc/hostapd.accept:\1/etc/hostapd/hostapd.accept:g' /etc/hostapd/hostapd.conf
	dosed 's:\(deny_mac_file=\)/etc/hostapd.deny:\1/etc/hostapd/hostapd.deny:g' /etc/hostapd/hostapd.conf
	dosbin hostapd
	dodoc \
		README \
		developer.txt
}
