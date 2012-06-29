# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/logmein-hamachi/logmein-hamachi-2.1.0.68.ebuild,v 1.1 2012/06/29 08:06:49 maksbotan Exp $

inherit eutils linux-info

DESCRIPTION="LogMeIn Hamachi VPN tunneling engine"
HOMEPAGE="https://secure.logmein.com/products/hamachi2"
SRC_URI="x86?	( https://secure.logmein.com/labs/${P}-x86.tgz )
	amd64?	( https://secure.logmein.com/labs/${P}-x64.tgz )"

LICENSE="LogMeIn"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="!net-misc/hamachi"

RESTRICT="mirror"

QA_PRESTRIPPED="/opt/${PN}/bin/hamachid"

pkg_setup() {
	einfo "Checking your kernel configuration for TUN/TAP support."
	CONFIG_CHECK="~TUN"
	check_extra_config
}

src_unpack() {
	unpack ${A}
	mv ${P}-$(use x86 && echo x86 || echo x64) "${S}" || die
}

src_install() {
	into /opt/${PN}
	dobin hamachid dnsup dnsdown || die
	dosym /opt/${PN}/bin/hamachid /usr/bin/hamachi || die "Couldn't create hamachi symlink"

	dodir /var/run/${PN} || die

	# Config and log directory
	dodir /var/lib/${PN} || die

	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die

	dodoc CHANGES README || die
}

pkg_postinst() {
	elog "LogMeIn Hamachi2 is installed."
	elog "Consult the README file on how to configure your client."
	elog "You can run the client 'hamachi' as root,"
	elog "or as a user if you add a line:"
	elog "Ipc.User      <login name>"
	elog "to the file '/var/lib/${PN}/h2-engine-override.cfg'"
	elog "and restart the daemon with"
	elog "/etc/init.d/${PN} restart"
	elog "To enable auto-login when the service starts set a nickname in"
	elog "/etc/conf.d/${PN}"
}
