# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88-r4.ebuild,v 1.4 2002/10/19 03:21:25 vapier Exp $

IUSE="ssl ipv6"

S=${WORKDIR}/${P}

DESCRIPTION="Collection of tools for managing UNIX services"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz
	ipv6? ( http://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff13.bz2 )
 	ssl? ( http://www.nrg4u.com/qmail/ucspi-tcp-ssl-20020705.patch.gz )"
HOMEPAGE="http://cr.yp.to/${PN}/"

DEPEND="virtual/glibc"
	#ssl? ( >=dev-libs/openssl-0.9.6g )
RDEPEND="${DEPEND}"

SLOT="0"
KEYWORDS="x86 sparc sparc64"
LICENSE="as-is"

src_unpack() {
	unpack ${A}
	cd ${S}

	use ipv6 && patch -p1 < ${WORKDIR}/ucspi-tcp-0.88-ipv6.diff13

	#use ssl && patch < ${WORKDIR}/ucspi-tcp-ssl-20020705.patch

	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	echo "/usr/" > conf-home
}

src_compile() {
	pmake || die
}

src_install() {
	for i in tcpserver tcprules tcprulescheck argv0 recordio tcpclient *\@ tcpcat mconnect mconnect-io addcr delcr fixcrio rblsmtpd
	do
		dobin $i
	done

	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
}
