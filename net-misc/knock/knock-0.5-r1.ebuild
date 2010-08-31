# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knock/knock-0.5-r1.ebuild,v 1.1 2010/08/31 09:33:43 xmw Exp $

EAPI=2

inherit eutils

DESCRIPTION="A simple port-knocking daemon"
HOMEPAGE="http://www.zeroflux.org/projects/knock"
SRC_URI="http://www.zeroflux.org/proj/knock/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="net-firewall/iptables
	${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch

	sed -i -e "s:/usr/sbin/iptables:/sbin/iptables:g" knockd.conf || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README TODO || die

	newinitd "${FILESDIR}"/knockd.initd knock || die
	newconfd "${FILESDIR}"/knockd.confd knock || die
}

pkg_postinst() {
	if ! has_version net-firewall/iptables ; then
		einfo
		elog "You're really encouraged to install net-firewall/iptables to"
		elog "actually modify your firewall and use the example configuration."
		einfo
	fi
}
