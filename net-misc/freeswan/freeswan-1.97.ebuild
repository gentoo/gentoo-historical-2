# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/freeswan/freeswan-1.97.ebuild,v 1.1 2002/05/23 19:37:31 ashmodai Exp $

S=${WORKDIR}/freeswan-1.97
DESCRIPTION="FreeS/WAN IPSec Userspace Utilities"
SRC_URI="ftp://ftp.xs4all.nl/pub/crypto/freeswan/${P}.tar.gz"
HOMEPAGE="http://www.freeswan.org"
DEPEND="virtual/glibc
        virtual/linux-sources"
LICENSE="GPL-2"
RDEPEND=""
SLOT="0"

pkg_setup() {
    [ -d /usr/src/linux/net/ipsec ] || {
		echo You need to have the crypto-enabled version of Gentoo Sources
		echo with a symlink to it in /usr/src/linux in order to have IPSec
		echo kernel compatibility.  Please emerge sys-kernel/crypto-sources, 
		echo compile an IPSec-enabled kernel and attempt this ebuild again.
		exit 1
	}
}

src_compile() {

	make	 						   	\
		DESTDIR=${D}					\
		USERCOMPILE="${CFLAGS}"			\
		FINALCONFDIR=/etc/ipsec			\
		INC_RCDEFAULT=/etc/init.d		\
		INC_USRLOCAL=/usr				\
		INC_MANDIR=share/man			\
		confcheck programs || die
}

src_install () {
	
	# try make prefix=${D}/usr install

	make 								\
		DESTDIR=${D}					\
		USERCOMPILE="${CFLAGS}"			\
		FINALCONFDIR=/etc/ipsec			\
		INC_RCDEFAULT=/etc/init.d		\
		INC_USRLOCAL=/usr				\
		INC_MANDIR=share/man			\
		install || die

	dodoc INSTALL COPYING CREDITS BUGS CHANGES README doc/*
}

