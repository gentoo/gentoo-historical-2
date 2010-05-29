# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/connman/connman-0.53.ebuild,v 1.2 2010/05/29 00:20:10 flameeyes Exp $

EAPI="2"

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="http://connman.net"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="bluetooth +caps debug +dhclient dnsproxy doc examples +ethernet google ofono policykit resolvconf threads tools +udev +wifi"
# gps meego ospm openconnect wimax

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2.24
	bluetooth? ( net-wireless/bluez )
	caps? ( sys-libs/libcap-ng )
	dhclient? ( net-misc/dhcp )
	ofono? ( net-misc/ofono )
	policykit? ( >=sys-auth/policykit-0.7 )
	resolvconf? ( net-dns/openresolv )
	udev? ( >=sys-fs/udev-141 )
	wifi? ( >=net-wireless/wpa_supplicant-0.7[dbus] )"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

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
		$(use_enable ofono ofono builtin) \
		$(use_enable dhclient dhclient builtin) \
		$(use_enable resolvconf resolvconf builtin) \
		$(use_enable dnsproxy dnsproxy builtin) \
		$(use_enable google google builtin) \
		$(use_enable policykit polkit builtin) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable threads) \
		$(use_enable tools) \
		$(use_enable udev) \
		--disable-udhcp \
		--disable-iwmx \
		--disable-iospm \
		--disable-hh2serial-gps \
		--disable-portal \
		--disable-meego \
		--disable-openconnect
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dobin client/cm || die "client installation failed"

	keepdir /var/lib/${PN} || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die
}
