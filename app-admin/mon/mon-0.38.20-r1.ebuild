# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/mon/mon-0.38.20-r1.ebuild,v 1.8 2002/07/08 14:22:47 sunflare Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Highly configurable service monitoring daemon"
SRC_URI="ftp://ftp.kernel.org/pub/software/admin/mon/${P}.tar.bz2"
HOMEPAGE="http://www.kernel.org/software/mon/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc"
RDEPEND=">=dev-perl/Mon-0.9
         >=dev-perl/Time-HiRes-01.20"

src_compile() {

    cd ${S}/mon.d
    make CC="gcc $CFLAGS" || die
}

src_install () {

    exeinto /usr/sbin
    doexe mon clients/mon*

    insinto /usr/lib/mon/utils
    doins utils/*

    exeinto /usr/lib/mon/alert.d ; doexe alert.d/*
    exeinto /usr/lib/mon/mon.d ; doexe mon.d/*.monitor
    insopts -g uucp -m 02555 ; doins mon.d/*.wrap
	
    dodir /var/log/mon.d
    dodir /var/lib/mon.d

    doman doc/*.1
    dodoc CHANGES COPYING CREDITS KNOWN-PROBLEMS
    dodoc mon.lsm README TODO VERSION
    docinto txt ; dodoc doc/README*
    docinto etc ; dodoc etc/*
    newdoc ${FILESDIR}/mon.cf mon.cf.sample

    exeinto /etc/init.d
    newexe ${FILESDIR}/mon.rc5 mon
    insinto /etc/mon
    newins ${FILESDIR}/mon.cf mon.cf.sample
}
