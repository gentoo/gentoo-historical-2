# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lvm-user/lvm-user-1.0.1_rc4.ebuild,v 1.5 2002/07/14 19:20:18 aliz Exp $

#our version, but with "eh" formatting
NV=1.0.1-rc4
S=${WORKDIR}/LVM/${NV}
DESCRIPTION="User-land utilities for LVM (Logical Volume Manager) software"
SRC_URI="ftp://ftp.sistina.com/pub/LVM/1.0/lvm_${NV}.tar.gz"
HOMEPAGE="http://www.mosix.org"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"
LICENSE="|"
LICENSE="LGPL-2"

DEPEND="virtual/glibc"

KS=/usr/src/linux

src_compile() {
	cd ${S}
	[ -f "Makefile" ] && ( make clean || die )
	CFLAGS="${CFLAGS} -I${KS}/include" \
		./configure --prefix=/ \
		--mandir=/usr/share/man \
		--with-kernel_dir="${KS}" || die
	make || die
}

src_install () {
	cd ${S}/tools
	CFLAGS="${CFLAGS} -I${KS}/include" \
		make install \
		-e prefix=${D} \
		mandir=${D}/usr/share/man \
		sbindir=${D}/sbin \
		libdir=${D}/lib || die
	#no need for a static library in /lib
	dodir /usr/lib
	mv ${D}/lib/*.a ${D}/usr/lib
}

