# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cbqinit/cbqinit-0.7.3.ebuild,v 1.2 2004/10/04 22:19:36 pvdabeel Exp $

DESCRIPTION="Sets up class-based queue traffic control (QoS) with iproute2"
HOMEPAGE="http://www.sourceforge.net/projects/cbqinit"
SRC_URI="mirror://sourceforge/cbqinit/cbq.init-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="sys-apps/iproute2"
DEPEND=""

S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/cbq.init-v${PV} ${S}
}

src_compile() {
	mv cbq.init-v${PV} cbq.init-v${PV}.orig
	sed <cbq.init-v${PV}.orig >cbq.init-v${PV} \
		-e 's|CBQ_PATH=${CBQ_PATH:-/etc/sysconfig/cbq}|CBQ_PATH=/etc/cbqinit|' \
		-e 's|CBQ_CACHE=${CBQ_CACHE:-/var/cache/cbq.init}|CBQ_CACHE=/var/cache/cbqinit|'
}

src_install() {
	mv cbq.init-v${PV} cbqinit

	exeinto /usr/sbin
	doexe cbqinit

	exeinto /etc/init.d
	newexe ${FILESDIR}/rc_cbqinit-r1 cbqinit

	insinto /etc/cbqinit/sample
	newins ${FILESDIR}/cbq-1280.My_first_shaper.sample cbq-1280.My_first_shaper

	dodoc cbqinit
}

pkg_postinst() {
	einfo 'Run "rc-update add cbqinit default" to run cbqinit at startup.'
}
