# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ipcad/ipcad-3.7.ebuild,v 1.8 2007/04/24 19:46:40 welp Exp $

inherit eutils

DESCRIPTION="IP Cisco Accounting Daemon"
HOMEPAGE="http://ipcad.sourceforge.net/"
SRC_URI="mirror://sourceforge/ipcad/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="net-libs/libpcap
	net-firewall/iptables"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-20060828-cvs.patch
}

src_install() {
	sed -i -e "s/^chroot = \/adm\/tmp;/chroot = \/var\/ipcad;/" ipcad.conf.default
	sed -i -e "s/^interface/#interface/" ipcad.conf.default
	sed -i -e "s/^aggregate/#aggregate/" ipcad.conf.default
	sed -i -e "s/^pidfile = ipcad.pid;/pidfile = \/run\/ipcad.pid;/" ipcad.conf.default

	dodoc AUTHORS ChangeLog README BUGS FAQ ipcad.conf.simple ipcad.conf.default
	dosbin ipcad

	insinto /etc
	insopts -m0600
	newins ipcad.conf.default ipcad.conf

	keepdir /var/ipcad/run

	doman ipcad.8 ipcad.conf.5

	newinitd "${FILESDIR}"/ipcad.init ipcad
	newconfd "${FILESDIR}"/ipcad.conf.d ipcad
}
