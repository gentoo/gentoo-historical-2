# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wpa_supplicant/wpa_supplicant-0.2.5-r1.ebuild,v 1.2 2005/01/03 11:09:01 brix Exp $

inherit toolchain-funcs eutils

MADWIFI_VERSION="0.1_pre20040906"

DESCRIPTION="WPA Supplicant for secure wireless transfers"
HOMEPAGE="http://hostap.epitest.fi/wpa_supplicant/"
SRC_URI="http://hostap.epitest.fi/releases/${P}.tar.gz
		mirror://gentoo/madwifi-driver-${MADWIFI_VERSION}.tar.bz2
		mirror://gentoo/${P}-ipw2100.diff.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="gsm pcap ssl"

DEPEND="sys-apps/sed
		dev-util/pkgconfig"
RDEPEND="gsm? ( sys-apps/pcsc-lite )
		pcap? ( net-libs/libpcap
				dev-libs/libdnet )
		ssl? ( dev-libs/openssl )"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${WORKDIR}/${P}-ipw2100.diff
	epatch ${FILESDIR}/${P}-pkg-config.patch

	sed -i "s:madwifi/wpa::" ${S}/Makefile

	sed -i "s:gcc:$(tc-getCC):g" ${S}/Makefile

	# Use pcap and libdnet if we have it.
	if use pcap; then
		sed -i "s:^#\(CFLAGS\):\1:" ${S}/Makefile
		sed -i "s:^#\(LIBS\):\1:" ${S}/Makefile
	fi

	cp ${FILESDIR}/${P}-config ${S}/.config || die

	if use ssl; then
		echo "CONFIG_EAP_TLS=y" >> ${S}/.config
		echo "CONFIG_EAP_PEAP=y" >> ${S}/.config
		echo "CONFIG_EAP_TTLS=y" >> ${S}/.config
	fi

	if use gsm; then
		echo "CONFIG_PCSC=y" >> ${S}/.config
	fi
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dosbin wpa_supplicant
	dobin wpa_cli wpa_passphrase

	dodoc ChangeLog COPYING developer.txt eap_testing.txt README todo.txt
	dodoc doc/wpa_supplicant.fig

	insinto /etc
	newins wpa_supplicant.conf wpa_supplicant.conf.example

	exeinto /etc/init.d
	newexe ${FILESDIR}/${P}-init.d wpa_supplicant

	insinto /etc/conf.d
	newins ${FILESDIR}/${P}-conf.d wpa_supplicant
}
