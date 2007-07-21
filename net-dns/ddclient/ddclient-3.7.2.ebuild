# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ddclient/ddclient-3.7.2.ebuild,v 1.1 2007/07/21 20:56:35 antarus Exp $

inherit eutils

DESCRIPTION="Perl updater client for dynamic DNS services"
HOMEPAGE="http://ddclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl"

RDEPEND=">=dev-lang/perl-5.1
	ssl? ( dev-perl/IO-Socket-SSL )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-reasonable-security.patch"

	einfo "Applying version string fix"
	if ! sed -i "s/3\.7\.1/$PV/" "$PN"; then
		eerror "Failed to update ddclient's internal version string"
		eerror 'ddclient 3.7.2 will erroneously report a version of 3.7.1'
	fi

	# Remove pid line, because it is specified in /etc/conf.d/ddclient
	einfo "Applying PID setup"
	if ! sed -i "/^pid=*/d" "sample-etc_${PN}.conf"; then
		eerror "Failed to remove pid from /etc/$PN/$PN.conf"
		eerror "Please set the PID in /etc/conf.d/$PN, not /etc/$PN/$PN.conf"
	fi

	if ! use ssl; then
		einfo "Disabling ssl per your useflags"
		sed -i "/^ssl=*/d" "sample-etc_${PN}.conf" ||
			eerror "Failed to remove ssl from /etc/$PN/$PN.conf"
	fi
}

src_install() {
	dosbin ${PN} || die "dosbin failed"
	dodoc README* Change* COPYRIGHT sample*

	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die "newinitd failed"

	# Filename of sample conf - use live filename if available
	local sample=${PN}.conf
	[[ -e "${ROOT}/etc/${PN}/${sample}" ]] && sample="${sample}.sample"

	insinto /etc/${PN}
	insopts -m 0640 -o root -g ${PN}
	newins sample-etc_${PN}.conf "${sample}" || die "newins conf failed"

	insinto /etc/conf.d
	insopts -m 0644 -o root -g root
	newins "${FILESDIR}"/${PN}.confd ${PN} || die "newins confd failed"

	diropts -m 0755 -o ${PN} -g ${PN}
	keepdir /var/{cache,run}/${PN}
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