# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/slidentd/slidentd-0.0.15.ebuild,v 1.9 2003/02/13 15:07:29 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A secure, lightweight ident daemon."
SRC_URI="http://www.uncarved.com/slidentd/${P}.tar.gz"
HOMEPAGE="http://www.uncarved.com/slidentd/"
KEYWORDS="x86 sparc "
LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-libs/dietlibc
	dev-libs/libowfat"

RDEPEND="sys-apps/daemontools
	sys-apps/ucspi-tcp"

src_unpack() {
	unpack ${A} ; cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:^\tCFLAGS=\$(diet_cflag.*:\tCFLAGS=${CFLAGS} \${diet_cflags}:" \
		-e "s:^\tCC\:=diet -Os \$(CC):\tCC\:=diet -Os gcc:" \
		Makefile.orig > Makefile
}

src_compile() {
	make build_mode=diet INCLUDES=-I/usr/include/libowfat LIBDIRS=-L/usr/lib || die
}

src_install () {
	make DESTDIR=${D} install || die

	exeinto /var/lib/supervise/slidentd
	newexe ${FILESDIR}/slidentd-run run
}

pkg_postinst() {
	echo -e "\e[32;01m You need to start your supervise service:\033[0m"
	echo ' # ln -s /var/lib/supervise/slidentd/ /service'
	echo
}
