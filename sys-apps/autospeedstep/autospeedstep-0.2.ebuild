# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/autospeedstep/autospeedstep-0.2.ebuild,v 1.3 2003/06/22 23:43:45 liquidx Exp $

DESCRIPTION="A daemon which controls power consumption and processor speed depending on CPU load"
HOMEPAGE="http://gpsdrive.kraftvoll.at/speedstep.shtml"
SRC_URI="http://gpsdrive.kraftvoll.at/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 -amd64 -alpha -arm -hppa -mips -sparc"
IUSE=""
DEPEND=""

src_compile() {
	econf
	emake || die
}

src_install() {
	einstall
	exeinto /etc/init.d
	doexe ${FILESDIR}/autospeedstep
}
