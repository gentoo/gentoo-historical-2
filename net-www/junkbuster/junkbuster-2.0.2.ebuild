# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/junkbuster/junkbuster-2.0.2.ebuild,v 1.13 2004/06/25 00:56:26 agriffis Exp $

S=${WORKDIR}/ijb20
DESCRIPTION="Filtering HTTP proxy"
SRC_URI="http://www.waldherr.org/redhat/rpm/srpm/junkbuster-2.0.2-8.tar.gz"
HOMEPAGE="http://internet.junkbuster.com"
KEYWORDS="x86 sparc ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"
RDEPEND="$DEPEND"

src_compile() {
	unset CXXFLAGS
	unset CFLAGS
	make || die
}

src_install () {
	dosbin junkbuster

	dodir /etc/init.d
	exeinto /etc/init.d
	newexe ${FILESDIR}/junkbuster.rc6 junkbuster

	dodir /etc/junkbuster
	insinto /etc/junkbuster
	doins blocklist config cookiefile forward imagelist

	dohtml gpl.html ijbman.html ijbfaq.html
	dodoc README README.TOO README.WIN squid.txt

	doman junkbuster.1

	dodir /var/log/junkbuster
}
