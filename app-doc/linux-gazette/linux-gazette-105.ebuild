# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-gazette/linux-gazette-105.ebuild,v 1.1 2004/09/23 14:34:42 vapier Exp $

DESCRIPTION="Sharing ideas and discoveries and Making Linux just a little more fun"
HOMEPAGE="http://linuxgazette.net/"
SRC_URI="http://linuxgazette.net/ftpfiles/lg-${PV}.tar.gz"

LICENSE="OPL"
SLOT="${PV}"
KEYWORDS="x86 ppc amd64"
IUSE=""

DEPEND=">=app-doc/linux-gazette-base-${PV}"

S=${WORKDIR}/lg

src_install() {
	dodir /usr/share/doc
	mv ${S} ${D}/usr/share/doc/${PN}/
}
