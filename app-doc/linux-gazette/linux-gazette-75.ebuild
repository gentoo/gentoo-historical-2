# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-gazette/linux-gazette-75.ebuild,v 1.4 2004/06/30 01:05:06 agriffis Exp $

DESCRIPTION="Sharing ideas and discoveries and Making Linux just a little more fun"
HOMEPAGE="http://linuxgazette.net/"
SRC_URI="http://linuxgazette.net/ftpfiles/lg-issue${PV}.tar.gz"

LICENSE="OPL"
SLOT="${PV}"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND=">=app-doc/linux-gazette-base-${PV}"

src_install() {
	dodir /usr/share/doc
	mv ${WORKDIR}/lg ${D}/usr/share/doc/${PN}
}
