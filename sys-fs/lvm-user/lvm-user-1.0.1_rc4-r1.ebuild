# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/lvm-user/lvm-user-1.0.1_rc4-r1.ebuild,v 1.1 2003/09/15 17:46:25 seemant Exp $

NV=1.0.1-rc4
S=${WORKDIR}/LVM/${NV}
DESCRIPTION="User-land utilities for LVM (Logical Volume Manager) software"
SRC_URI="ftp://ftp.sistina.com/pub/LVM/1.0/lvm_${NV}.tar.gz"
HOMEPAGE="http://www.mosix.org"
KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="GPL-2 | LGPL-2"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}
	!sys-apps/lvm2"

KS=/usr/src/linux

src_compile() {
	cd ${S}
	#This ebuild doesn't like this opt setting; closes bug #598
	export CFLAGS="${CFLAGS/-fomit-frame-pointer/}"
	if [ -f "Makefile" ]; then
		make clean || die
	fi
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

