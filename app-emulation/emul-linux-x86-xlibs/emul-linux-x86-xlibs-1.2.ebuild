# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-xlibs/emul-linux-x86-xlibs-1.2.ebuild,v 1.1 2004/08/22 10:54:16 lv Exp $

DESCRIPTION="X11R6 libraries for emulation of 32bit x86 on amd64"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~lv/emul-linux-x86-xlibs-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND="virtual/libc
	>=app-emulation/emul-linux-x86-baselibs-1.2.1"

S=${WORKDIR}

src_install() {
	mkdir -p ${D}/etc/env.d/
	echo "LDPATH=/usr/X11R6/lib32" > ${D}/etc/env.d/75emul-linux-x86-xlibs
	cp -Rpvf ${WORKDIR}/* ${D}/
}
