# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88-r5.ebuild,v 1.1 2003/03/05 20:41:47 vapier Exp $

inherit eutils

DESCRIPTION="Collection of tools for managing UNIX services"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz
	ipv6? ( http://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff13.bz2 )
 	ssl? ( http://www.nrg4u.com/qmail/ucspi-tcp-ssl-20020705.patch.gz )"
HOMEPAGE="http://cr.yp.to/ucspi-tcp.html"

SLOT="0"
KEYWORDS="x86 sparc"
LICENSE="as-is"
IUSE="ssl ipv6"

DEPEND="virtual/glibc
	ssl? ( >=dev-libs/openssl-0.9.6g )"

src_unpack() {
	unpack ${A}
	cd ${S}

	if use ipv6; then 
		epatch ${WORKDIR}/ucspi-tcp-0.88-ipv6.diff13
	elif use ssl; then
		epatch ${WORKDIR}/ucspi-tcp-ssl-20020705.patch
	fi
	epatch ${FILESDIR}/${PV}-errno.patch

	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	echo "/usr/" > conf-home
}

src_compile() {
	pmake || die
}

src_install() {
	dobin tcpserver tcprules tcprulescheck argv0 recordio tcpclient *\@ tcpcat mconnect mconnect-io addcr delcr fixcrio rblsmtpd
	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
}
