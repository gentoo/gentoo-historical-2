# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88-r2.ebuild,v 1.6 2002/10/19 04:06:04 vapier Exp $

DESCRIPTION="Collection of tools for managing UNIX services"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz
	http://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff11.bz2"
HOMEPAGE="http://cr.yp.to/${PN}/"
S=${WORKDIR}/${P}
DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"
SLOT="0"
KEYWORDS="x86 sparc sparc64"
LICENSE="as-is"

src_unpack() {
	unpack ${P}.tar.gz
	use ipv6 && bzcat ${DISTDIR}/ucspi-tcp-0.88-ipv6.diff11.bz2 | patch -d ${S} -p1
	cd ${S}
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
