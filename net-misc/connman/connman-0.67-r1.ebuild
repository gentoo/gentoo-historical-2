# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/connman/connman-0.67-r1.ebuild,v 1.2 2011/01/25 13:47:16 dev-zero Exp $

EAPI="2"

inherit multilib eutils

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="http://connman.net"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="bluetooth +caps debug dnsproxy doc examples +ethernet google ofono ntpd openvpn policykit threads tools +wifi wimax"
# gps meego ospm openconnect

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2.24
	>=dev-libs/libnl-1.1
	>=net-firewall/iptables-1.4.8
	net-libs/gnutls
	bluetooth? ( net-wireless/bluez )
	caps? ( sys-libs/libcap-ng )
	ntpd? ( net-misc/ntp )
	ofono? ( net-misc/ofono )
	policykit? ( sys-auth/polkit )
	openvpn? ( net-misc/openvpn )
	wifi? ( >=net-wireless/wpa_supplicant-0.7[dbus] )
	wimax? ( net-wireless/wimax )"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.30
	doc? ( dev-util/gtk-doc )"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-policy-name.patch"
}

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-client \
		--enable-fake \
		--enable-datafiles \
		--enable-loopback=builtin \
		$(use_enable caps capng) \
		$(use_enable examples test) \
		$(use_enable ethernet ethernet builtin) \
		$(use_enable wifi wifi builtin) \
		$(use_enable bluetooth bluetooth builtin) \
		$(use_enable ntpd ntpd builtin) \
		$(use_enable ofono ofono builtin) \
		$(use_enable dnsproxy dnsproxy builtin) \
		$(use_enable google google builtin) \
		$(use_enable openvpn openvpn builtin) \
		$(use_enable policykit polkit builtin) \
		$(use_enable wimax iwmx builtin) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable threads) \
		$(use_enable tools) \
		--disable-iospm \
		--disable-hh2serial-gps \
		--disable-portal \
		--disable-meego \
		--disable-openconnect
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dobin client/cm || die "client installation failed"

	keepdir /var/"$(get_libdir)"/${PN} || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die
}
