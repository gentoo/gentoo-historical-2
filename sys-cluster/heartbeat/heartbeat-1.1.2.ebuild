# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/heartbeat/heartbeat-1.1.2.ebuild,v 1.1 2003/07/22 14:09:23 iggy Exp $

DESCRIPTION="Heartbeat high availability cluster manager"
HOMEPAGE="http://www.linux-ha.org"
SRC_URI="http://www.linux-ha.org/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE=""

DEPEND="dev-libs/popt
	dev-libs/glib
	net-libs/libnet
	snmp? ( virtual/snmp )"

src_compile() {

	econf || die

	emake || die

}

src_install() {

	make DESTDIR=${D} install || die
	exeinto /etc/init.d
	newexe ${FILESDIR}/heartbeat-init heartbeat

}
