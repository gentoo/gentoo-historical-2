# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/super-freeswan/super-freeswan-1.99.7.3.ebuild,v 1.4 2004/04/27 21:49:06 agriffis Exp $

inherit eutils

MY_P=${P/_p/_kb}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Super FreeS/WAN IPSec Userspace Utilities"
SRC_URI="http://download.freeswan.ca/super-freeswan/${MY_P}.tar.gz"

HOMEPAGE="http://www.freeswan.ca/code/super-freeswan/"
DEPEND="virtual/glibc
	virtual/linux-sources
	>=dev-libs/gmp-3.1.1"
LICENSE="GPL-2"
RDEPEND=""
SLOT="0"
KEYWORDS="~x86"

pkg_setup() {
	[ -d /usr/src/linux/net/ipsec ] || {
		echo You need to have the crypto-enabled version of Gentoo Sources
		echo with a symlink to it in /usr/src/linux in order to have IPSec
		echo kernel compatibility.  Please emerge sys-kernel/crypto-sources,
		echo compile an IPSec-enabled kernel and attempt this ebuild again.
		exit 1
	}
}

src_unpack() {
	unpack ${A}

	# Patch that fixes some bad CFLAGS specified in the Makefiles.
	# Closes Bug #29783
	epatch ${FILESDIR}/${P}-bad-cflags-fix.patch
}

src_compile() {
	cp ${S}/libdes/Makefile ${S}/libdes/Makefile.orig
	sed s:/usr/local:/usr:g < ${S}/libdes/Makefile.orig \
		> ${S}/libdes/Makefile
	cp ${S}/libdes/Makefile ${S}/libdes/Makefile.orig
	sed s:/usr/man:/usr/share/man:g < ${S}/libdes/Makefile.orig \
		> ${S}/libdes/Makefile

	make	 				   	\
		DESTDIR=${D}				\
		USERCOMPILE="${CFLAGS}"			\
		FINALCONFDIR=/etc/ipsec			\
		INC_RCDEFAULT=/etc/init.d		\
		INC_USRLOCAL=/usr			\
		INC_MANDIR=share/man			\
		confcheck programs || die
}

src_install () {

	# try make prefix=${D}/usr install

	make 						\
		DESTDIR=${D}				\
		USERCOMPILE="${CFLAGS}"			\
		FINALCONFDIR=/etc/ipsec			\
		INC_RCDEFAULT=/etc/init.d		\
		INC_USRLOCAL=/usr			\
		INC_MANDIR=share/man			\
		install || die

	dodoc INSTALL COPYING CREDITS BUGS CHANGES README doc/*
	dosym /etc/ipsec/ipsec.d /etc/ipsec.d
}

