# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snortsam/snortsam-2.31.ebuild,v 1.1 2005/03/18 10:49:36 ka0ttic Exp $

inherit eutils

DESCRIPTION="Snort plugin that allows automated blocking of IP addresses on several firewalls"
HOMEPAGE="http://www.snortsam.net/"
SRC_URI="http://www.snortsam.net/files/snortsam-v2_multi-threaded/${PN}-src-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-2.29-no-ugly----lines.diff
}

src_compile() {
	sed -i "s: -O2 : ${CFLAGS} :" makesnortsam.sh || die "sed failed"
	sh makesnortsam.sh || die "makesnortsam.sh failed"
}

src_install() {
	find ${S} -type d -name CVS -exec rm -rf {} \;
	find ${S} -type f -name "*.asc" -exec rm -f {} \;
	dobin snortsam || die "dobin failed"
	dodoc docs/* conf/*
}

pkg_postinst() {
	echo
	einfo "To use snortsam with snort, you'll have to compile snort with USE=snortsam."
	einfo "Read the INSTALL file to configure snort for snortsam, and configure"
	einfo "snortsam for your particular firewall."
	echo
}


