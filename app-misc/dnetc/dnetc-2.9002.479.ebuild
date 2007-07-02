# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dnetc/dnetc-2.9002.479.ebuild,v 1.9 2007/07/02 14:16:13 peper Exp $

MAJ_PV=${PV:0:6}
MIN_PV=${PV:7:9}

DESCRIPTION="distributed.net client"
HOMEPAGE="http://www.distributed.net"
SRC_URI="hppa? ( http://http.distributed.net/pub/dcti/v${MAJ_PV}/dnetc${MIN_PV}-linux-hppa32.tar.gz )"
LICENSE="distributed.net"
SLOT="0"
KEYWORDS="~hppa -mips"
IUSE=""
DEPEND=""
RDEPEND="net-dns/bind-tools"
if use hppa; then
	S="${WORKDIR}/dnetc${MIN_PV}-linux-hppa"
fi

RESTRICT="mirror"

pkg_preinst() {
	if [ -e /opt/distributed.net/dnetc ] && [ -e /etc/init.d/dnetc ]; then
		einfo "flushing old buffers"
		/opt/distributed.net/dnetc -quiet -flush
		einfo "removing old buffer files"
		rm -f /opt/distributed.net/buff*
	fi
}

src_install() {
	exeinto /opt/distributed.net
	doexe dnetc

	doman dnetc.1
	dodoc CHANGES.txt dnetc.txt readme.*

	newinitd ${FILESDIR}/dnetc.init dnetc
	newconfd ${FILESDIR}/dnetc.conf dnetc
}

pkg_postinst() {
	elog "Either configure your email address in /etc/conf.d/dnetc"
	elog "or create the configuration file /opt/distributed.net/dnetc.ini"
}

pkg_postrm() {
	if [ -d /opt/distributed.net ]; then
		elog "All files has not been removed from /opt/distributed.net"
	fi
}
