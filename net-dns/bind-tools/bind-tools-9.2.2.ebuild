# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/bind-tools/bind-tools-9.2.2.ebuild,v 1.8 2003/09/07 00:09:56 msterret Exp $

MY_P=${P//-tools}
MY_P=${MY_P/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="bind tools: dig, nslookup, and host"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${PV/_}/${MY_P}.tar.gz"
HOMEPAGE="http://www.isc.org/products/BIND/bind9-beta.html"

KEYWORDS="x86 ~ppc sparc alpha hppa arm amd64"
LICENSE="as-is"
SLOT="0"

DEPEND="virtual/glibc"

src_compile() {
	econf || die "configure failed"

	export MAKEOPTS="${MAKEOPTS} -j1"

	cd ${S}/lib/isc
	emake || die "make failed in /lib/isc"

	cd ${S}/lib/dns
	emake || die "make failed in /lib/dns"

	cd ${S}/bin/dig
	emake || die "make failed in /bin/dig"
}

src_install() {
	cd ${S}/bin/dig
	dobin dig host nslookup
	doman dig.1 host.1

	doman ${FILESDIR}/nslookup.8

	cd ${S}
	dodoc  README CHANGES FAQ COPYRIGHT
}
