# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/phxd/phxd-0.1.0_pre23092005.ebuild,v 1.3 2007/01/09 16:23:54 kang Exp $

inherit eutils

DESCRIPTION="Next generation Hotline server in python. kang's branch."
HOMEPAGE="http://www.avaraline.net"
SRC_URI="mirror://gentoo/phxd-0.1.0_pre23092005.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"

DEPEND="dev-python/twisted
	dev-python/twisted-web"

RDEPEND=""

pkg_postinst() {
	enewgroup phxd || die "Failed to create phxd group"
	enewuser phxd -1 /bin/bash /var/phxd phxd || "Failed to create phxd user"
	chown phxd:phxd /var/phxd/files
	chown phxd:phxd /var/phxd/chatlogs
}

src_install() {
	cd ${WORKDIR}
	cd phxd

	insinto /etc/env.d; doins ${FILESDIR}/80phxd

	dodoc INSTALL README README-kang
	dodir /var/phxd

	exeinto /var/phxd; doexe phxd

	cpdirs="support shared server client"
	for i in $cpdirs; do
		cp -R $i ${D}/var/phxd
	done
	dodir /var/phxd/files
	dodir /var/phxd/chatlogs

	keepdir /var/phxd/files
	keepdir /var/phxd/chatlogs
	keepdir /var/phxd

	insinto /var/phxd; doins config.py
}
