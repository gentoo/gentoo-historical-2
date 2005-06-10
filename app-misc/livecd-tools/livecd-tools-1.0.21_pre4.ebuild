# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/livecd-tools/livecd-tools-1.0.21_pre4.ebuild,v 1.1 2005/06/10 13:18:13 wolf31o2 Exp $

IUSE="opengl X"

DESCRIPTION="Gentoo LiveCD tools for autoconfiguration of hardware"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~wolf31o2/sources/livecd-tools/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc hppa alpha ppc64"

RDEPEND=">=sys-apps/sed-4
	x86? ( opengl? ( virtual/opengl
			>=x11-base/opengl-update-2.2.1 )
		X? ( virtual/x11
			sys-apps/pciutils
			x11-misc/mkxf86config
			sys-apps/gawk ) )"

src_install() {
	doinitd autoconfig
	newinitd spind.init spind
	if use x86
	then
		use X && dosbin x-setup && newinitd x-setup.init x-setup
		use opengl && dosbin openglify
	fi
	dosbin net-setup spind
	into /
	dobin bashlogin
	dosbin livecd-functions.sh
}
