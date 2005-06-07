# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/http-replicator/http-replicator-3.0.ebuild,v 1.7 2005/06/07 21:35:26 griffon26 Exp $

DESCRIPTION="Proxy cache for Gentoo packages"
HOMEPAGE="http://gertjan.freezope.org/replicator/"
SRC_URI="http://gertjan.freezope.org/replicator/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~alpha ~amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.3"

src_compile() {
	einfo "No compilation necessary"
}

src_install(){
	# Daemon and repcacheman into /usr/bin
	exeinto /usr/bin
	doexe http-replicator
	newexe ${FILESDIR}/http-replicator-3.0-callrepcacheman-0.1 repcacheman
	if has_version '>=sys-apps/portage-2.0.51'; then
		newexe ${FILESDIR}/http-replicator-3.0-repcacheman-0.33 repcacheman.py
	else
		newexe ${FILESDIR}/http-replicator-3.0-repcacheman-0.21 repcacheman.py
	fi

	# Config file into /etc/conf.d
	insinto /etc/conf.d
	newins ${FILESDIR}/http-replicator-3.0.conf http-replicator

	# Docs
	dodoc README debian/changelog

	# init.d scripts
	exeinto /etc/init.d
	newexe ${FILESDIR}/http-replicator-3.0.init http-replicator

	# Man Page - Not Gentooified yet
	doman http-replicator.1

	insinto /etc/logrotate.d
	newins debian/logrotate http-replicator
}

pkg_postinst() {
	einfo
	einfo "Before starting http-replicator, please follow the next few steps:"
	einfo "- modify /etc/conf.d/http-replicator if required"
	einfo "- run /usr/bin/repcacheman to set up the cache"
	einfo "- add HTTP_PROXY=\"http://serveraddress:8080\" to make.conf on"
	einfo "  the server as well as on the client machines"
	einfo "- make sure GENTOO_MIRRORS in /etc/make.conf starts with several"
	einfo "  good http mirrors"
	einfo
	einfo "For more information please refer to the following forum thread:"
	einfo "  http://forums.gentoo.org/viewtopic-t-173226.html"
	einfo
}
