# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tcp-wrappers/tcp-wrappers-7.6-r4.ebuild,v 1.1 2002/04/06 06:40:22 gbevin Exp $

MY_P="tcp_wrappers_${PV}"
PATCH0="${MY_P}.dif"
PATCH1="${MY_P}-ipv6-1.6.diff.gz"
PATCH2="${MY_P}-stdc.diff"
S=${WORKDIR}/${MY_P}
DESCRIPTION="tcp wrappers"
SRC_URI="ftp://ftp.porcupine.org/pub/security/${MY_P}.tar.gz"

DEPEND="virtual/glibc"


src_unpack() {

	unpack ${A}
	
	cd ${S}/
	patch -p0 < ${FILESDIR}/${PATCH0} || die
	gzip -dc ${FILESDIR}/${PATCH1} | patch -p2 || die
	patch -p0 < ${FILESDIR}/${PATCH2} || die
	
	cp Makefile Makefile.orig
	sed -e "s/-O2/${CFLAGS}/" \
		-e "s:AUX_OBJ=.*:AUX_OBJ= \\\:" Makefile.orig > Makefile
}

src_compile() {

	make ${MAKEOPTS} \
		REAL_DAEMON_DIR=/usr/sbin \
		linux || die
}

src_install() {

	dosbin tcpd tcpdchk tcpdmatch safe_finger try-from
	doman *.[358]
	dosym hosts_access.5.gz /usr/share/man/man5/hosts.allow.5.gz
	dosym hosts_access.5.gz /usr/share/man/man5/hosts.deny.5.gz
	dolib.a libwrap.a
	insinto /usr/include
	doins tcpd.h

	dodoc BLURB CHANGES DISCLAIMER README*
}

