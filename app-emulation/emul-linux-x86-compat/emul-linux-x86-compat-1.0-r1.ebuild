# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-compat/emul-linux-x86-compat-1.0-r1.ebuild,v 1.2 2006/01/05 21:52:04 herbs Exp $

DESCRIPTION="emul-linux-x86 version of lib-compat, with the addition of a 32bit libgcc_s and the libstdc++ versions provided by gcc 3.3 and 3.4 for non-multilib systems."
SRC_URI="mirror://gentoo/emul-linux-x86-compat-${PV}.tar.bz2"
HOMEPAGE="http://www.gentoo.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* amd64"
IUSE=""

# stop confusing portage 0.o
S=${WORKDIR}

DEPEND="virtual/libc
	>=app-emulation/emul-linux-x86-glibc-1.0"

src_unpack() {
	unpack ${A}
	# Remove libsmpeg to avoid collision with emul-sdl
	rm -f ${S}/emul/linux/x86/usr/lib/libsmpeg*
}

src_install() {
	mkdir -p ${D}
	# everything should already be in the right place :)
	cp -Rpvf ${WORKDIR}/* ${D}/
	doenvd ${FILESDIR}/75emul-linux-x86-compat
}
