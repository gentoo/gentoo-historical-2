# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/simpserver-bin/simpserver-bin-0.9.ebuild,v 1.1 2004/03/13 08:17:51 eradicator Exp $

MY_PN=${PN/-bin/}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SimpServer for Unix: IM instant security transparent proxy"
SRC_URI="http://www.secway.fr/resources/setup/simpserver/${MY_P}-linux-x86.tgz"
HOMEPAGE="http://www.secway.fr/"
LICENSE="simpserver-test"

KEYWORDS="-* ~x86"
SLOT="0"
S=${WORKDIR}/simp

src_compile() {
	einfo "Binary distribution.  No compilation required."
}

src_install () {
	dodoc LICENSE README VERSION doc/CONFIG doc/TODO

	exeinto /usr/sbin
	doexe bin/${MY_PN}

	insinto /etc
	doins etc/simp.conf

	exeinto /etc/init.d
	newexe ${FILESDIR}/${MY_PN}.rc ${MY_PN}
}

pkg_postinst() {
	einfo "Please edit the configuration file: /etc/simp.conf."
}
