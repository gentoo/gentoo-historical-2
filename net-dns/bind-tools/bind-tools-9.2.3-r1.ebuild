# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/bind-tools/bind-tools-9.2.3-r1.ebuild,v 1.2 2004/02/22 22:39:53 agriffis Exp $

MY_P=${P//-tools}
MY_P=${MY_P/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="bind tools: dig, nslookup, and host"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${PV/_}/${MY_P}.tar.gz"
HOMEPAGE="http://www.isc.org/products/BIND/bind9-beta.html"

KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64"
LICENSE="as-is"
SLOT="0"

DEPEND="virtual/glibc"

src_compile() {

	# Set -fPIC compiler option to enable compilation on 64-bit archs
	# (Bug #33336)
	if use alpha || use amd64 || use ia64; then
		append-flags -fPIC
	fi

	use ipv6 && myconf="${myconf} --enable-ipv6" || myconf="${myconf} --enable-ipv6=no"

	econf ${myconf} || die "Configure failed"

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
