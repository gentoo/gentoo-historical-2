# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gluelog/gluelog-1.0.ebuild,v 1.1 2000/12/10 04:21:36 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Pipe and socket fittings for the system and kernel logs"
SRC_URI=""

src_compile() {                           
	mkdir ${S}
	cd ${FILESDIR}
	gcc ${CFLAGS} gluelog.c -o ${S}/gluelog
	gcc ${CFLAGS} glueklog.c -o ${S}/glueklog
}

src_unpack() {
	echo
}

src_install() {
	dodir /usr/sbin
	dosbin ${S}/gluelog ${S}/glueklog
	exeopts -m0750 -g wheel
	install -d -m0750 -o root -g wheel ${D}/etc/svc.d/control
	dodir /var/log
	local x
	for x in syslog klog
	do
		exeinto /etc/svc.d/services/${x}
		newexe ${FILESDIR}/${x}-run run
		ln -s ../services/${x} ${D}/etc/svc.d/control/${x}
		touch ${D}/etc/svc.d/services/${x}/down
		install -d -m0750 -o daemon -g wheel ${D}/var/log/${x}.d
	done
	exeopts -m0755
	exeinto /etc/rc.d/init.d
	doexe ${FILESDIR}/sysklogd
}

pkg_preinst() {
	if [ -e ${ROOT}/etc/rc.d/init.d/sysklogd ]
	then
		${ROOT}/etc/rc.d/init.d/sysklogd stop
	fi
	${ROOT}/usr/sbin/rc-update del sysklogd
}

pkg_postinst() {
	${ROOT}/usr/sbin/rc-update add sysklogd
	${ROOT}/etc/rc.d/init.d/sysklogd start
}
