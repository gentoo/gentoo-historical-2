# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-gazette/linux-gazette-86.ebuild,v 1.2 2004/02/21 05:28:21 vapier Exp $

DESCRIPTION="Sharing ideas and discoveries and Making Linux just a little more fun"
HOMEPAGE="http://linuxgazette.net/"
SRC_URI="http://linuxgazette.net/ftpfiles/lg-issue${PV}.tar.gz"

LICENSE="OPL"
SLOT="${PV}"
KEYWORDS="x86 ppc"

DEPEND=">=app-doc/linux-gazette-base-${PV}"

src_install() {
	dodir /usr/share/doc
	mv ${WORKDIR}/lg ${D}/usr/share/doc/${PN}
}
