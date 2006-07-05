# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-baselibs/emul-linux-x86-baselibs-2.5.1.ebuild,v 1.2 2006/07/05 18:36:26 blubb Exp $

DESCRIPTION="Base libraries for emulation of 32bit x86 on amd64"
SRC_URI="mirror://gentoo/${P}.tar.bz2
		http://dev.gentoo.org/~blubb/${P}.tar.bz2"
HOMEPAGE="http://www.gentoo.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* amd64"
IUSE=""

S=${WORKDIR}

RDEPEND="virtual/libc
	app-emulation/emul-linux-x86-compat"

RESTRICT="nostrip"

src_install() {
	cd ${WORKDIR}
	cp -RPvf ${WORKDIR}/* ${D}/

	doenvd ${FILESDIR}/75emul-linux-x86-base
}
