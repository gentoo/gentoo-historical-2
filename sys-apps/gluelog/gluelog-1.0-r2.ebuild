# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gluelog/gluelog-1.0-r2.ebuild,v 1.13 2004/06/14 08:12:56 mr_bones_ Exp $

DESCRIPTION="Pipe and socket fittings for the system and kernel logs"
HOMEPAGE="http://www.linuxuser.co.za/projects.php3"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc "
IUSE=""

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
