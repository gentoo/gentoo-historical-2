# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gluelog/gluelog-1.0-r2.ebuild,v 1.2 2001/12/31 23:47:55 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Pipe and socket fittings for the system and kernel logs"
SRC_URI=""

DEPEND="virtual/glibc"

src_compile() {

	mkdir ${S}

	cd ${FILESDIR}
	gcc ${CFLAGS} gluelog.c -o ${S}/gluelog || die
	gcc ${CFLAGS} glueklog.c -o ${S}/glueklog || die
}

src_install() {

	dodir /usr/sbin
	dosbin ${S}/gluelog ${S}/glueklog
	exeopts -m0750 -g wheel
	dodir /var/log
	local x
	for x in syslog klog
	do
		exeinto /var/lib/supervise/services/${x}
		newexe ${FILESDIR}/${x}-run run
		install -d -m0750 -o daemon -g wheel ${D}/var/log/${x}.d
		exeinto /etc/rc.d/init.d
		doexe ${FILESDIR}/svc-${x}
	done

        dodoc ${FILESDIR}/README
}

