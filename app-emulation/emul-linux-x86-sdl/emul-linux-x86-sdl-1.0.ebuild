# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-sdl/emul-linux-x86-sdl-1.0.ebuild,v 1.3 2005/01/01 14:11:34 eradicator Exp $

DESCRIPTION="32bit SDL emulation for amd64"
SRC_URI="http://dev.gentoo.org/~lv/emul-linux-x86-sdl-1.0.tar.bz2"
HOMEPAGE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* amd64"
IUSE=""

DEPEND="virtual/libc
	>=app-emulation/emul-linux-x86-xlibs-1.0"

src_install() {
	mkdir -p ${D}
	# everything should already be in the right place :)
	cp -Rpvf ${WORKDIR}/* ${D}
}
