# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tcp-wrappers/tcp-wrappers-7.6-r5.ebuild,v 1.2 2003/02/09 19:26:55 gmsoft Exp $

inherit eutils

MY_P="${PN//-/_}_${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="tcp wrappers"
SRC_URI="ftp://ftp.porcupine.org/pub/security/${MY_P}.tar.gz"
HOMEPAGE="ftp://ftp.porcupine.org/pub/security/index.html"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa"
SLOT="0"
LICENSE="freedist"
DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	
	cd ${S}/
	epatch ${FILESDIR}/${PV}-patches
	
	cp Makefile Makefile.orig
	sed -e "s/-O/${CFLAGS} -fPIC/" \
		-e "s:AUX_OBJ=.*:AUX_OBJ= \\\:" \
		-e "s:SOMINOR = 7.6:SOMINOR = ${PV}:" Makefile.orig > Makefile

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
	dolib.so shared/libwrap.so.0.${PV}
	dosym /usr/lib/libwrap.so.0.${PV} /usr/lib/libwrap.so.0
	dosym /usr/lib/libwrap.so.0 /usr/lib/libwrap.so
	insinto /usr/include
	doins tcpd.h

	dodoc BLURB CHANGES DISCLAIMER README*
}
