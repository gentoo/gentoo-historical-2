# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# Author Thilo Bangert <bangert@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/clockspeed/clockspeed-0.62-r1.ebuild,v 1.5 2002/04/27 21:46:45 bangert Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a simple ntp client"
SRC_URI="http://cr.yp.to/clockspeed/${P}.tar.gz"
HOMEPAGE="http://cr.yp.to/"

DEPEND="virtual/glibc
	sys-apps/groff"
RDEPEND="virtual/glibc"


src_compile() {
    cd ${S}
    patch -p1 < ${FILESDIR}/${PF}-gentoo.diff
    cp -a conf-cc conf-cc.orig
    sed "s/@CFLAGS@/${CFLAGS}/" < conf-cc.orig > conf-cc
    emake || die
}

src_install () {
    dodir /etc /usr/bin /usr/sbin /usr/share/man/man1
    insinto /etc
    doins leapsecs.dat

    into /usr
    dobin clockspeed clockadd clockview sntpclock taiclock taiclockd
    doman clockspeed.1 clockadd.1 clockview.1 sntpclock.1 taiclock.1 taiclockd.1

    exeinto /usr/sbin
    newexe ${FILESDIR}/ntpclockset ntpclockset

    dodoc BLURB CHANGES README THANKS TODO INSTALL
}

pkg_postinst() {

    echo
    einfo "Use ntpclockset to set your clock!"
    echo

}
