# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/livecd-tools/livecd-tools-1.0.3.ebuild,v 1.4 2004/06/02 13:18:57 wolf31o2 Exp $

IUSE="opengl X"

DESCRIPTION="LiveCD tools (autoconfig, net-setup)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~wolf31o2/livecd/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~amd64 ~ppc ~hppa"

DEPEND=""

src_install() {
	use x86 && exeinto /etc/init.d && doexe autoconfig
	use x86 && use X && dosbin x-setup
	use opengl && dosbin opengl-update openglify
	dosbin net-setup
}
