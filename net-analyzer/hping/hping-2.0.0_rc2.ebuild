# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/hping/hping-2.0.0_rc2.ebuild,v 1.7 2003/11/20 19:49:00 avenj Exp $

S=${WORKDIR}/hping2-rc2
DESCRIPTION="A ping-like TCP/IP packet assembler/analyzer."
SRC_URI="http://www.hping.org/hping2.0.0-rc2.tar.gz"
HOMEPAGE="http://www.hping.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc hppa ia64 ~amd64"

DEPEND="net-libs/libpcap"

src_compile() {
	./configure || die

	if [ `use debug` ]
	then
		make CCOPT="${CFLAGS}" || die
	else
		make CCOPT="${CFLAGS}" || die
	fi
}

src_install () {
	cd ${S}

	dodir /usr/sbin
	dosbin hping2
	dosym /usr/sbin/hping2 /usr/sbin/hping

	doman docs/hping2.8
	dodoc INSTALL KNOWN-BUGS NEWS README TODO AUTHORS BUGS CHANGES COPYING
}
