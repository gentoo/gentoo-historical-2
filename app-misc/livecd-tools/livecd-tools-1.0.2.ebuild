# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/livecd-tools/livecd-tools-1.0.2.ebuild,v 1.8 2004/10/05 13:34:51 pvdabeel Exp $

IUSE=""

DESCRIPTION="LiveCD tools (autoconfig, net-setup)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~zhen/${P}.tar.bz2
		mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc hppa ~alpha ppc"

DEPEND=""

S=${WORKDIR}/${PN}

src_install() {
	if use x86
	then
		exeinto /etc/init.d
		doexe autoconfig
	fi
	dosbin net-setup
}
