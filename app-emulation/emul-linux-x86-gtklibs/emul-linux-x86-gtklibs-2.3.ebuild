# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-gtklibs/emul-linux-x86-gtklibs-2.3.ebuild,v 1.4 2006/03/09 01:50:09 flameeyes Exp $

DESCRIPTION="Gtk+ 1/2 for emulation of 32bit x86 on amd64"
SRC_URI="mirror://gentoo/${P}.tar.bz2
		http://dev.gentoo.org/~herbs/emul/${P}.tar.bz2"
HOMEPAGE="http://www.gentoo.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* amd64"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=app-emulation/emul-linux-x86-xlibs-2.0
	>=app-emulation/emul-linux-x86-baselibs-2.0"

RESTRICT="nostrip"

src_install() {
	cp -RPvf ${WORKDIR}/* ${D}/
	doenvd ${FILESDIR}/50emul-linux-x86-gtklibs
}
