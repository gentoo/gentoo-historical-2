# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ddclient/ddclient-3.8.1.ebuild,v 1.2 2012/06/14 02:02:30 zmedico Exp $

EAPI="4"

inherit user

DESCRIPTION="Perl updater client for dynamic DNS services"
HOMEPAGE="http://ddclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="ssl"

RDEPEND=">=dev-lang/perl-5.1
		 ssl? ( dev-perl/IO-Socket-SSL )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	# Remove pid line, because it is specified in /etc/conf.d/ddclient
	einfo "Applying PID setup"
	if ! sed '/^pid/d' -i "sample-etc_${PN}.conf"; then
		eerror "Failed to remove pid from /etc/${PN}/${PN}.conf"
		eerror "Please set the PID in /etc/conf.d/${PN}, not /etc/${PN}/${PN}.conf"
	fi

	if ! use ssl; then
		einfo "Disabling SSL per your USE flags"
		sed '/^ssl/,/ssl-library$/d' -i "sample-etc_${PN}.conf" || \
			eerror "Failed to remove ssl from /etc/$PN/$PN.conf"
	fi
}

src_install() {
	dosbin ${PN}
	dodoc Change* COPYRIGHT README* RELEASENOTE sample*

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	keepdir /var/{cache,run}/${PN}
	fowners -R ${PN}:${PN} /var/{cache,run}/${PN}

	insinto /etc/${PN}
	insopts -m 0600 -o ${PN} -g ${PN}
	newins sample-etc_${PN}.conf ${PN}.conf
	newins sample-etc_${PN}.conf ${PN}.conf.sample
	fowners -R ${PN}:${PN} /etc/${PN}
}

pkg_postinst() {
	use ssl && return
	ewarn
	ewarn "$PN will not have support for ssl, which means your dynamic DNS account"
	ewarn "information -- including your password -- will be sent over the Internet in the"
	ewarn "clear. To secure your information, add 'ssl' to your USEflags,"
	ewarn "emerge -N ddclient, and add 'ssl=yes' to /etc/$PN/$PN.conf"
	ewarn
}
