# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Terry Chan <tchan@enteract.com>
# $Header: /var/cvsroot/gentoo-x86/net-misc/ntp/ntp-4.1.71.ebuild,v 1.2 2001/10/10 20:10:05 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Network Time Protocol suite/programs"
SRC_URI="http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/${P}.tar.gz"
HOMEPAGE="http://www.ntp.org/"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2
	>=sys-libs/readline-4.1"

src_compile() {
	cp configure configure.orig
	sed -e "s:-Wpointer-arith::" configure.orig > configure
	LDFLAGS="$LDFLAGS -lncurses"

	./configure --prefix=/usr --mandir=/usr/share/man \
	--host=${CHOST} --build=${CHOST} || die

	emake || die
}

src_install () {
	make prefix=${D}/usr mandir=${D}/usr/share/man install || die

	dodoc ChangeLog INSTALL NEWS README TODO WHERE-TO-START
	insinto /usr/share/doc/${PF}/html ; doins html/*.htm
	insinto /usr/share/doc/${PF}/html/hints ; doins html/hints/*
	insinto /usr/share/doc/${PF}/html/pic ; doins html/pic/*

	insinto /usr/share/ntp ; doins scripts/*

	exeinto /etc/rc.d/init.d ; newexe ${FILESDIR}/ntpd.rc5 ntpd
}
